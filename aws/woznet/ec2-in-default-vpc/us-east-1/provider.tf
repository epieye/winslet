provider "aws" {
  region = "us-east-1"
  profile = "ourzoo-root"
}

# Never mind. kindaida route53 is in Ourzoo account.
provider "aws" {
  alias = "KIN"
  region = "us-east-1"
  profile = "kinaida"
}



// I don't like drifiting away from how datascan does it.
provider "kubernetes" {	
  //load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}
