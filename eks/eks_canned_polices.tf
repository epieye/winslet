#resource "aws_iam_role_policy_attachment" "datascan-dev-worker-policy" {
#  policy_arn = aws_iam_policy.datascan-worker.arn
#  role       = aws_iam_role.datascan.name
#}
#
#resource "aws_iam_role_policy_attachment" "ssm_role_attach_instance_core" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#  role       = aws_iam_role.datascan.name
#}
#
#resource "aws_iam_role_policy_attachment" "datascan-AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.datascan.name
#}
#
#resource "aws_iam_role_policy_attachment" "datascan-AmazonEKSServicePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#  role       = aws_iam_role.datascan.name
#}
#resource "aws_iam_role_policy_attachment" "datascan-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.datascan.name
#}
#
#resource "aws_iam_role_policy_attachment" "datascan-AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.datascan.name
#}
#
#resource "aws_iam_role_policy_attachment" "datascan-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.datascan.name
#}
#
#resource "aws_iam_role_policy_attachment" "eks_efs_csi_driver_policy" {
#  policy_arn = aws_iam_policy.eks_efs_csi_policy.arn
#  role       = aws_iam_role.eks_efs_csi_role.name
#}
#
