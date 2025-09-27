resource "aws_iam_user" "testing1" {
  name = "testing1"     
  
}
resource "aws_iam_policy_attachment" "attach1" {
  name       = "attach1"
  users      = [aws_iam_user.testing1.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_eks_access_entry" "testing1" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.testing1.arn
  type          = "STANDARD"
}

# resource "aws_eks_access_entry" "himanshu" {
#   cluster_name  = module.eks.cluster_name
#   principal_arn = "arn:aws:iam::619512840514:user/awsuser" # or a role ARN
#   type          = "STANDARD"
# }



