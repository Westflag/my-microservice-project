resource "aws_eks_addon" "aws_ebs_csi_driver" { cluster_name = aws_eks_cluster.this.name addon_name = "aws-ebs-csi-driver" }
