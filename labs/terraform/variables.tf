variable "regiao" {
  type        = string
  description = "Região dos buckets. O budget usa us-east-1, que é onde a API de billing responde."
  default     = "sa-east-1"
}

variable "ambiente" {
  type    = string
  default = "dev"
}

variable "alerta_email" {
  type        = string
  description = "Se preenchido, cria um budget mensal de 5 dólares com alerta em 80%."
  default     = ""
}
