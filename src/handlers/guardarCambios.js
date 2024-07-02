const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event));

    const hiloId = event.pathParameters.id;
    const { titulo, mensaje, usuarioId, fechaCreacion, link } = JSON.parse(event.body);

    if (!hiloId) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: 'El ID del hilo es requerido'})
        };
    }

    if (!titulo || !mensaje || !usuarioId) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: 'El título, mensaje y usuarioId son requeridos'})
        };
    }

    const params = {
        TableName: process.env.THREADS_TABLE,
        Key: {
            id: hiloId
        },
        UpdateExpression: 'set titulo = :titulo, mensaje = !mensaje, usuarioId = :usuarioId, fechaCreacion = :fechaCreacion, link = :link',
        ExpressionAttributeValues: {
            ':titulo': titulo,
            ':mensaje': mensaje,
            ':usuarioId': usuarioId,
            ':fechaCreacion': fechaCreacion || new Date().toISOString(),
            ':link': link || ''
        },
        ReturnValues: 'UPDATED_NEW'
    };

    try {
        const result = await dynamodb.update(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify({message: 'Hilo actualizado exitosamente', updatedAttributes: result.Attributes})
        };
    } catch (error) {
        console.error("Error al actualizar el hilo:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({error: 'Error al actualizar el hilo'})
        };
    }
};

