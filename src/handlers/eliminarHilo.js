const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event));

    const hiloId = event.pathParameters.id;

    if (!hiloId) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: 'El ID del hilo es requerido'})
        };
    }

    const params = {
        TableName: process.env.THREADS_TABLE,
        Key: {
            id: hiloId
        }
    };

    try {
        await dynamodb.delete(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify({message: 'Hilo eliminado exitosamente'})
        };
    } catch (error) {
        console.error("Error al eliminar el hilo:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({error: 'Error al eliminar el hilo'})
        };
    }
};