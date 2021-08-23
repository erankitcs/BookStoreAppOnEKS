using AWS.EKS.Bookstore.Clients_API.Models;
using AWS.EKS.Bookstore.Clients_API.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System;
using System.Threading;
using System.Threading.Tasks;
using Amazon.XRay.Recorder.Core;
using Amazon.XRay.Recorder.Handlers.AwsSdk;
using Amazon.XRay.Recorder.Handlers.System.Net;
using Amazon.XRay.Recorder.Core.Internal.Entities;

namespace AWS.EKS.Bookstore.Clients_API.Controllers
{
    [ApiController]
    [Route("[action]")]
    public class ClientsController : ControllerBase
    {
        private readonly ClientService _clientService;

        //private readonly ILogger<WeatherForecastController> _logger;

        //public WeatherForecastController(ILogger<WeatherForecastController> logger)
        //{
        //    _logger = logger;
        //}
        public ClientsController(ClientService clientService)
        {
            _clientService = clientService;
        }

        [HttpGet]
        public async Task<ActionResult<List<Client>>> List() {
            AWSXRayRecorder.Instance.BeginSegment("Clients API");
            var clients = await _clientService.List();
            AWSXRayRecorder.Instance.EndSegment();
            return clients;
        }

        [Route("/get/{id}")]
        [HttpGet("/get/{id:length(38)}", Name = "GetClient")]
        public async Task<ActionResult<Client>> Get(string id) 
        {
            AWSXRayRecorder.Instance.BeginSegment("Clients API");
            var client = await _clientService.Get(id);
            AWSXRayRecorder.Instance.EndSegment();

            if(client == null) 
                return NotFound();

            return client;
        }

        [Route("/health")]
        [HttpGet("/health", Name = "HealthClient")]
        public async Task<ActionResult<Client>> Get() 
        {
            return Ok("Clients API is up and running.");
        }


        [HttpPost]
        public async Task<ActionResult<Client>> Create(Client client)
        {
            AWSXRayRecorder.Instance.BeginSegment("Clients API");
            await _clientService.Create(client);
            AWSXRayRecorder.Instance.EndSegment();
            return Ok(client);
        }

        [Route("/update/{id}")]
        [HttpPut("/update/{id:length(37)}")]
        public async Task<ActionResult<Client>> Update(string id, Client newClientData)
        {
            // AWSXRayRecorder.Instance.BeginSegment("Clients API");
            var client = _clientService.Get(id);
            // AWSXRayRecorder.Instance.EndSegment();
            
            newClientData.Id = id;

            if(client == null) 
                return NotFound();

            AWSXRayRecorder.Instance.BeginSegment("Clients API");
            await _clientService.Update(newClientData);
            AWSXRayRecorder.Instance.EndSegment();

            return Ok(newClientData);
        }
    }
}
