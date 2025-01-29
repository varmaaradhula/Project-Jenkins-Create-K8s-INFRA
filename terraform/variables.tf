variable "region" {
    description = "AWS region"
    type = string
    default = "eu-west-2"
}

variable "clusterName" {
    description = "Cluster name"
    type = string
    default = "myvpro-EKS-Cluster"
}