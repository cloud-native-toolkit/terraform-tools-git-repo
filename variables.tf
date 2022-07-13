variable "host" {
  type        = string
  description = "The host for the git repository."
}

variable "org" {
  type        = string
  description = "The org/group where the git repository exists/will be provisioned."
}

variable "repo" {
  type        = string
  description = "The short name of the repository (i.e. the part after the org/group name)"
}

variable "username" {
  type        = string
  description = "The username used to access the repository"
}

variable "token" {
  type        = string
  description = "The personal access token used to access the repository"
  sensitive   = true
}

variable "public" {
  type        = bool
  description = "Flag indicating that the repo should be public or private"
  default     = false
}

variable "project" {
  type        = string
  description = "The project that will be used for the git repo"
  default     = ""
}

variable "strict" {
  type        = bool
  description = "Flag indicating that an error should be thrown if the repo already exists"
  default     = false
}

variable "debug" {
  type        = bool
  default     = false
  description = "Flag incidicating that debug logging should be shown"
}
