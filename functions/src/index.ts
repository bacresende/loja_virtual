import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands, CaptureRequestModel, CancelTransactionRequestModel } from 'cielo';
admin.initializeApp(functions.config().firebase);

//CaptureRequestModel, CancelTransactionRequestModel, TransactionCreditCardResponseModel
// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// const merchantId = functions.config().cielo.merchantid;
// const merchantKey = functions.config().cielo.merchantkey;

const merchantId = '2e8ca7f4-6e29-4dd6-dskfnasjka89b-529de043e01f';
const merchantKey = 'b97ULgvRiv3v8WfTJYldfjkdnsfjklKQJG9TlhRDvzu3ujpjPkAf';

const cieloParams: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: false,
  debug: false,
}

const cielo = new Cielo(cieloParams);


export const authorizeCreditCard = functions.https.onCall(async (data, context) => {
  if (data === null) {

    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados não informados"
      }
    };

  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Usuário não logado"
      }
    };
  }

  const userId = context.auth.uid;

  const snapshot = await admin.firestore().collection("users").doc(userId).get();
  const userData = snapshot.data() || {};

  console.log("INICIANDO AUTORIZAÇÃO");
  console.log(userData);
  console.log(data.creditCard.brand);
  console.log(data);


  let brand: EnumBrands;

  switch (data.creditCard.brand) {
    case "VISA":
      brand = EnumBrands.VISA;
      break;
    case "MASTERCARD":
      brand = EnumBrands.MASTER;
      break;
    case "AMEX":
      brand = EnumBrands.AMEX;
      break;
    case "ELO":
      brand = EnumBrands.ELO;
      break;
    case "JCB":
      brand = EnumBrands.JCB;
      break;
    case "DINERSCLUB":
      brand = EnumBrands.DINERS;
      break;
    case "DISCOVER":
      brand = EnumBrands.DISCOVERY;
      break;
    case "HIPERCARD":
      brand = EnumBrands.HIPERCARD;
      break;
    default:
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Bandeira do Cartão " + data.creditCard.brand + " não suportada"
        }
      };

  }

  const saleData: TransactionCreditCardRequestModel = {
    merchantOrderId: data.merchantOrderId,
    customer: {
      name: userData.name,
      identity: data.cpf,
      identityType: 'CPF',
      email: userData.email,
      /* deliveryAddress: {
         street: "Rua 9",
         number: "502",
         complement: "sem complemento",
         zipCode: "71908540",
         city: "Aguas Claras ",
         state: "Brasilia",
         country: 'BRA',
         district: "Distrito Federal",
 
       },*/

    },
    payment: {
      currency: 'BRL',
      country: 'BRA',
      amount: data.amount,
      installments: data.installments,
      softDescriptor: data.softDescriptor,
      type: data.paymentType,
      capture: false,
      creditCard: {
        cardNumber: data.creditCard.cardNumber,
        brand: brand,
        holder: data.creditCard.holder,
        expirationDate: data.creditCard.expirationDate,
        securityCode: data.creditCard.securityCode

      }
    }
  }

  try {

    const transaction = await cielo.creditCard.transaction(saleData);

    console.log("PEGANDO CÓDIGO DA TRANSAÇÃO");
    console.log(transaction.payment.status);
    console.log(transaction.payment.returnCode);

    if (transaction.payment.status === 1) {
      return {
        "success": true,
        "paymentId": transaction.payment.paymentId
      };
    } else {
      let message = '';
      switch (transaction.payment.returnCode) {
        case "5":
          message = 'Não Autorizada';
          break;
        case "57":
          message = 'Cartão Expirado';
          break;
        case "78":
          message = 'Cartão Bloqueado';
          break;
        case "99":
          message = 'Timeout';
          break;
        case "77":
          message = 'Cartão Cancelado';
          break;
        case "70":
          message = 'Problemas com o Cartão de Crédito';
          break;
        default:
          message = transaction.payment.returnMessage;
          break;
      }

      return {
        "success": false,
        "status": transaction.payment.status,
        "error": {
          "code": transaction.payment.returnCode,
          "message": message
        }
      };
    }
  } catch (error) {
    console.log('error', error)
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": 'Erro indefinido ' + error.response[0]
      }
    };
  }

});

export const captureCreditCard = functions.https.onCall(async (data, context) => {

  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados não informados"
      }
    };

  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Usuário não logado"
      }
    };
  }

  const captureParams: CaptureRequestModel = {
    paymentId: data.payId
  };

  try {

    const capture = await cielo.creditCard.captureSaleTransaction(captureParams);

    if (capture.status === 2) {

      return { 'success': true };
    } else {
      return {
        'success': false,
        'status': capture.status,
        'error': {
          'code': capture.returnCode,
          'message': capture.returnMessage
        }
      };
    }
  } catch (error) {
    console.log('error', error);
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": 'Erro indefinido ' + error.response[0]
      }
    };
  }
});

export const cancelCreditCard = functions.https.onCall(async (data, context) => {

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Usuário não logado"
      }
    };
  }

  const snapshot = await admin.firestore().collection('users').doc(context.auth.uid).get();
  const dataUser = snapshot.data() || {};
  console.log('DADOS DO USUARIOOOOOO CANCELAMENTO');
  console.log(dataUser);
  console.log(dataUser.payId);

  const cancelParams: CancelTransactionRequestModel = {
    paymentId: dataUser.payId

  };

  try {

    const cancel = await cielo.creditCard.cancelTransaction(cancelParams);

    if (cancel.status === 10 || cancel.status === 11) {

      return { 'success': true };
    } else {
      return {
        'success': false,
        'status': cancel.status,
        'error': {
          'code': cancel.returnCode,
          'message': cancel.returnMessage
        }
      };
    }
  } catch (error) {
    console.log('error', error);
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": 'Erro indefinido ' + error.response[0]
      }
    };
  }
});






export const helloWorld = functions.https.onCall((data, context) => {
  functions.logger.info("Hello logs!", { structuredData: true });

  return {
    data: "Hello From Cloud Functions!!!"
  };
});

export const getUserData = functions.https.onCall(async (data, context) => {
  console.log(context.auth?.uid);
  if (!context.auth) {
    return {
      "data": "Nenhum usuário logado"
    }
  }
  console.log(context.auth.uid);
  const snapshot = await admin.firestore().collection('users').doc(context.auth.uid).get();
  console.log(snapshot.data());
  return {
    "data": snapshot.data()
  }
});

export const addMessage = functions.https.onCall(async (data, context) => {
  console.log(data);

  const snapshot = await admin.firestore().collection('messages').add(data);

  return { 'success': snapshot.id };
});

export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate(async (snapshot, context) => {

  const orderId = context.params.orderId
  //const uid = context.auth?.uid || '';
  const querySnapshot = await admin.firestore().collection('admins').get();

  const admins = querySnapshot.docs.map(doc => doc.id);
  

  let adminsTokens: string[] = [];

  for (let i = 0; i < admins.length; i++) {
    const tokensAdmins: string[] = await getDeviceTokens(admins[i]);

    adminsTokens = adminsTokens.concat(tokensAdmins);
  }

  await sendPushFCM(
    adminsTokens,
    'Novo Pedido ',
    'Nova venda realizada. Pedido: ' + orderId,
  );

});

export const onOrderStatusChanged = functions.firestore.document("/orders/{orderId}").onUpdate(async (snapshot, context)=>{
  const orderId = context.params.orderId;

  const beforeStatus = snapshot.before.data().status;
  const afterStatus = snapshot.after.data().status;

  if(beforeStatus !== afterStatus){
    const idUser = snapshot.after.data().idUsuario;

    const userTokens = await getDeviceTokens(idUser);

    await sendPushFCM(
      userTokens,
      'Pedido: ' + orderId,
      'Status Atualizado Para: ' + afterStatus,
    );

  }

});

async function getDeviceTokens(uid: string) {
  const querySnapshot = await admin.firestore().collection('users').doc(uid).collection('tokens').get();

  const tokens = querySnapshot.docs.map(doc => doc.id);

  return tokens;
}

async function sendPushFCM(tokens: string[], title: string, message: string) {
  if (tokens.length > 0) {
    const payload = {
      notification: {
        title: title,
        body: message,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return admin.messaging().sendToDevice(tokens, payload);
  }
  return;
}


