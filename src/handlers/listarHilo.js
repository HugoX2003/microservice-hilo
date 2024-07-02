const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event));

    const params = {
        TableName: process.env.THREADS_TABLE //Nombre de la tabla DynamoDB almacenado en una variable de entorno
    };

    try{
        const data  = await dynamodb.scan(params).promise();
        const items = data.Items.map(item => ({
            id:            item.id,
            titulo:        item.titulo,
            mensaje:       item.mensaje,
            usuarioId:     item.usuarioId,
            fechaCreacion: item.fechaCreacion,
            link:          item.link
        }));

        return {
            statusCode: 200,
            body: JSON.stringify(items)
        };
    } catch (error) {
        console.error("Error al listar hilos:", error);
        return{
            statusCode: 500,
            body: JSON.stringify({error: 'Error al listar hilos'})
        };
    }
};