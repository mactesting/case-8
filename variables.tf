variable "project" { 
    type = string  
    default = "case8" 
}
variable "region"  { 
    type = string  
    default = "us-east-1" 
}
variable "vpc_cidr" { 
    type = string 
    default = "10.0.0.0/16" 
}
variable "az_count" { 
    type = number 
    default = 2 
}
variable "eks_version" { 
    type = string 
    default = "1.32" 
}
variable "node_desired" { 
    type = number 
    default = 2 
}
variable "node_max"     { 
    type = number 
    default = 4 
}
variable "node_min"     { 
    type = number 
    default = 2 
}
