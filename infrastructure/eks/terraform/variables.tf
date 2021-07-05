variable "domain_name" {
    description = "Domain name for ACM to use."
    default = "dev.techenvision.net"
    type    = string
}

variable "environment" {
    description = "Environment of the cluster"
    default = "developement"
    type = string
}