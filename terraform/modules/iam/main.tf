# terraform/modules/iam/main.tf

# Data source to fetch the TLS certificate for the OIDC provider
data "tls_certificate" "eks_oidc" {
  url = var.eks_oidc_url
}

# IAM OIDC Provider for Kubernetes Service Accounts
resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url = var.eks_oidc_url
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]
}

# IAM Role and Policy for AWS Load Balancer Controller
# Assume Role Policy Document for the ALB Controller Role
data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.eks_oidc_provider.arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:sub"
      # This service account must be created in Kubernetes (typically by Helm chart for ALB Controller)
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller_role" {
  name               = "${var.project_name}-alb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json
}

# ALB Controller Policy - Extensive permissions required
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${var.project_name}-ALBIngressControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "iam:CreateServiceLinkedRole",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          # ... (rest of the extensive permissions from previous code)
          "ec2:DescribeBundleTasks",
          "ec2:DescribeByoipCidrs",
          "ec2:DescribeCapacityReservations",
          "ec2:DescribeCarrierGateways",
          "ec2:DescribeClassicLinkInstances",
          "ec2:DescribeClientVpnEndpoints",
          "ec2:DescribeCoipPools",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeEgressOnlyInternetGateways",
          "ec2:DescribeElasticGpus",
          "ec2:DescribeExportImageTasks",
          "ec2:DescribeFastLaunchImages",
          "ec2:DescribeFleetHistory",
          "ec2:DescribeFleets",
          "ec2:DescribeFlowLogs",
          "ec2:DescribeFpgaImages",
          "ec2:DescribeHostReservations",
          "ec2:DescribeHosts",
          "ec2:DescribeIamInstanceProfileAssociations",
          "ec2:DescribeImages",
          "ec2:DescribeImportImageTasks",
          "ec2:DescribeImportSnapshotTasks",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceCreditSpecifications",
          "ec2:DescribeInstanceEventWindows",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstances",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeIpamPools",
          "ec2:DescribeIpams",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLocalGatewayRouteTablePermissions",
          "ec2:DescribeLocalGatewayRouteTables",
          "ec2:DescribeLocalGatewayVirtualBorderRouters",
          "ec2:DescribeLocalGatewayVirtualBorderRoutersVpns",
          "ec2:DescribeLocalGateways",
          "ec2:DescribeManagedPrefixLists",
          "ec2:DescribeMovingAddresses",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeNetworkInsightsAccessScopeAnalyses",
          "ec2:DescribeNetworkInsightsAccessScopes",
          "ec2:DescribeNetworkInsightsAnalyses",
          "ec2:DescribeNetworkInsightsPaths",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribePlacementGroups",
          "ec2:DescribePrefixLists",
          "ec2:DescribePrincipalIdFormat",
          "ec2:DescribePublicIpv4Pools",
          "ec2:DescribeRegions",
          "ec2:DescribeReplaceRootVolumeTasks",
          "ec2:DescribeReservedInstances",
          "ec2:DescribeReservedInstancesOfferings",
          "ec2:DescribeReservedInstancesOptions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroupReferences",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshotAttribute",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSpotDatafeedSubscription",
          "ec2:DescribeSpotFleetRequestHistory",
          "ec2:DescribeSpotFleetRequests",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeTrafficMirrorFilters",
          "ec2:DescribeTrafficMirrorSessions",
          "ec2:DescribeTrafficMirrorTargets",
          "ec2:DescribeTransitGatewayAttachments",
          "ec2:DescribeTransitGatewayConnectPeers",
          "ec2:DescribeTransitGatewayConnects",
          "ec2:DescribeTransitGatewayMulticastDomains",
          "ec2:DescribeTransitGatewayPeeringAttachments",
          "ec2:DescribeTransitGatewayPolicyTables",
          "ec2:DescribeTransitGatewayRouteTableAnnouncements",
          "ec2:DescribeTransitGatewayRouteTables",
          "ec2:DescribeTransitGatewayVpcAttachments",
          "ec2:DescribeTransitGateways",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcClassicLink",
          "ec2:DescribeVpcClassicLinkDnsSupport",
          "ec2:DescribeVpcEndpointConnectionNotifications",
          "ec2:DescribeVpcEndpointConnections",
          "ec2:DescribeVpcEndpointServiceConfigurations",
          "ec2:DescribeVpcEndpointServicePermissions",
          "ec2:DescribeVpcEndpointServices",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpnConnections",
          "ec2:DescribeVpnGateways",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeAddresses",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:RevokeSecurityGroupIngress",
          "elasticloadbalancing:DescribeAccountLimits",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:SetWebAcl",
          "elasticloadbalancing:TagResource",
          "elasticloadbalancing:UntagResource",
          "elasticloadbalancing:DeregisterTargets",
          "wafv2:GetWebACL",
          "wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "tag:GetResources",
          "tag:TagResources",
          "tag:UntagResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",
          "sns:Publish",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricAlarm",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ],
        "Resource": "*",
        "Sid": "ALBControllerPolicy"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}