var AWSXRay = require('aws-xray-sdk');
const express = require('express');
const morgan = require('morgan');

AWSXRay.captureHTTPsGlobal(require('http'));
AWSXRay.captureHTTPsGlobal(require('https'));

const http_client = require('http');
const https_client = require('https');

const app = express();
const AWS = AWSXRay.captureAWS(require('aws-sdk'));
const uuidv1 = require('uuid/v1');
const async = require('async');
const { url } = require('inspector');

app.use(morgan('short'));
app.use(express.json());

var AWSXRay = require('aws-xray-sdk');
const { response } = require('express');
AWSXRay.config([AWSXRay.plugins.ECSPlugin]);
app.use(AWSXRay.express.openSegment('Inventory API'));
const port = 5001;
const resourceApiEndpont = process.env.RESOURCE_API_ENDPOINT || 'http://localhost:5000';
const dynamodbTable = process.env.DYNAMODB_TABLE || 'development-inventory' ;
const awsDefaultRegion = process.env.AWS_DEFAULT_REGION || 'us-east-2'
const dynamoDb = new AWS.DynamoDB.DocumentClient({region: awsDefaultRegion});
app.use(AWSXRay.express.openSegment('Inventory API'));

app.post('/register', (request, response) => {
    inventoryRegistryJson = request.body;
    resourceApiUrl = resourceApiEndpont + '/get/' + inventoryRegistryJson.ResourceId;
    client = resourceApiUrl.startsWith("http://") ? http_client : https_client;
    resourceApiResponse = client.get(resourceApiUrl, (resp) =>{
        let data = '';
        resp.on('data', (chunk) => {
            data +=chunk;
        });
        resp.on('end', () =>{
            if (inventoryRegistryJson.Available == undefined) {
                inventoryRegistryJson.Available = true
            }
            inventoryRegistryJson._id = uuidv1();
            var params = {
                TableName: dynamodbTable,
                Item: inventoryRegistryJson
            }
            dynamoDb.put(params, function(err, data){
                if (err) {
                    console.log(err)
                    response.status(500)
                        .json({ success: false, message: 'Error: Server error' });
                }
                else{
                    console.log('data', data);
                    response.status(201)
                        .json({ 'insertedId': inventoryRegistryJson._id })
                }
            })
        });
        resp.on('error', (err) => {
            if(resp.statusCode == 404) {
                response.status(404)
                .json({'message': "The resource wasn't found."})
            } else {
                console.log(err)
            }
        });
    })
})