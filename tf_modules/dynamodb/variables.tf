variable "namespace" {
  description = "The namespace which this table belongs to"
  type        = string
  //default     = "development"
}

variable "api_name" {
  description = "The API name which this table belongs to"
  type        = string
}

variable "table_name" {
  description = "The table name of DynamoDB"
  type        = string
}

variable "hash_key" {
  description = "Hash Key for table of DynamoDB"
  type        = string
}

variable "attributes" {
  description = "Attributes  for table of DynamoDB"
  type        = list(map(string))
  default     = []
}