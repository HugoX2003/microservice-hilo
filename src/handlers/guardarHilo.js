const dynamodb = require('../utils/dynamodb');
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();
const { v4: uuidv4 } = require('uuid'); // Para generar un ID único

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event));

    const { titulo, mensaje, usuarioId, fechaCreacion, link } = JSON.parse(event.body);

    if (!titulo || !mensaje || !usuarioId) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: 'El título, mensaje y usuarioId son requeridos'})
        };
    }

    const hiloId = uuidv4(); // Generar un ID único para el nuevo hilo

    const params = {
        TableName: process.env.THREADS_TABLE,
        Item: {
            id:            hiloId,
            titulo:        titulo,
            mensaje:       mensaje,
            usuarioId:     usuarioId,
            fechaCreacion: fechaCreacion || new Date().toISOString(),
            link:          link || ''
        }
    };

    try {
        await dynamodb.put(params).promise();
        return {
            statusCode: 201,
            body: JSON.stringify({message: 'Hilo guardado exitosamente', hiloId: hiloId})
        };
    } catch (error) {
        console.error("Error al guardar el hilos:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({error: 'Error al guardar el hilo'})
        };
    }
};