resource "aws_iam_role" "hashology" {
  name = var.tags["Name"]

}

resource "aws_iam_policy" "hashology-worker" {
  name = "${var.tags["Name"]}-worker"
  description = "${var.tags["Name"]}-worker"
}

#resource "aws_iam_role_policy_attachment" "hashology-dev-worker-policy" {
#  policy_arn = aws_iam_policy.hashology-worker.arn
#  role       = aws_iam_role.hashology.name
#}
#
#resource "aws_iam_role_policy_attachment" "hashology-AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.hashology.name
#}
#
#resource "aws_iam_role_policy_attachment" "hashology-AmazonEKSServicePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#  role       = aws_iam_role.hashology.name
#}
#resource "aws_iam_role_policy_attachment" "hashology-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.hashology.name
#}


