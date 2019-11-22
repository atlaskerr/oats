local vpc = {
  stack:: {
    name: 'vpc-${environment}',
    template_path: './vpc/template.yaml',
    enabled: true,
    variables: {
      Environment: '${namespace}-${environment}-${region}',
      CidrBlock: '${vpc_cidr}',
    },
  },
  outputs:: {
    id:: '${output vpc-${environment}::VpcId}',
  },
};

local subnets = {
  stack:: {
    name: 'subnets-${environment}',
    template_path: './subnets/template.yaml',
    enabled: true,
    variables: {
      Namespace: '${namespace}-${environment}-${region}',
      VpcId: vpc.outputs.id,
      SubnetPublicOneCidr: '${subnet_public_one_cidr}',
      SubnetPublicTwoCidr: '${subnet_public_two_cidr}',
      SubnetPrivateOneCidr: '${subnet_private_one_cidr}',
      SubnetPrivateTwoCidr: '${subnet_private_two_cidr}',
    },
  },
  outputs:: {
    publicOneId:: '${output subnets-${environment}::SubnetPublicOneId}',
    publicTwoId:: '${output subnets-${environment}::SubnetPublicTwoId}',
    privateOneId:: '${output subnets-${environment}::SubnetPrivateOneId}',
    privateTwoId:: '${output subnets-${environment}::SubnetPrivateTwoId}',
  },
};

local gateways = {
  stack:: {
    name: 'gateways-${environment}',
    template_path: './gateways/template.yaml',
    enabled: true,
    variables: {
      Namespace: '${namespace}-${environment}-${region}',
      VpcId: vpc.outputs.id,
      SubnetPublicOneId: subnets.outputs.publicOneId,
      SubnetPublicTwoId: subnets.outputs.publicTwoId,
    },
  },
  outputs:: {
    internetGatewayId:: '${output gateways-${environment}::InternetGatewayId}',
    natGatewayOneId:: '${output gateways-${environment}::NatGatewayOneId}',
    natGatewayTwoId:: '${output gateways-${environment}::NatGatewayTwoId}',
  },
};

local roles = {
  stack:: {
    name: 'roles-${environment}',
    template_path: './roles/template.yaml',
    enabled: true,
    variables: {
      Namespace: '${namespace}-${environment}-${region}',
    },
  },
  outputs:: {},
};

local securityGroups = {
  stack:: {
    name: 'security-groups-${environment}',
    template_path: './security-groups/template.yaml',
    enabled: true,
    variables: {
      VpcId: vpc.outputs.id,
    },
  },
  outputs:: {
    bastion:: '${output security-groups-${environment}::SecurityGroupBastionId}',
    vpn:: '${output security-groups-${environment}::SecurityGroupVpnId}',
    playground:: '${output security-groups-${environment}::SecurityGroupPlaygroundId}',
    efs:: '${output security-groups-${environment}::SecurityGroupEfsId}',
    asg:: '${output security-groups-${environment}::SecurityGroupAsgId}',
    elb:: '${output security-groups-${environment}::SecurityGroupElbId}',
  },
};

local routes = {
  stack:: {
    name: 'routes-${environment}',
    template_path: './routes/template.yaml',
    enabled: true,
    variables: {
      Namespace: '${namespace}-${environment}-${region}',
      VpcId: vpc.outputs.id,
      InternetGatewayId: gateways.outputs.internetGatewayId,
      NatGatewayOneId: gateways.outputs.natGatewayOneId,
      NatGatewayTwoId: gateways.outputs.natGatewayTwoId,
      SubnetPublicOneId: subnets.outputs.publicOneId,
      SubnetPublicTwoId: subnets.outputs.publicTwoId,
      SubnetPrivateOneId: subnets.outputs.privateOneId,
      SubnetPrivateTwoId: subnets.outputs.privateTwoId,
    },
  },
  outputs:: {},
};

local bastion = {
  stack:: {
    name: 'svc-bastion-${environment}',
    template_path: './services/bastion/template.yaml',
    enabled: true,
    variables: {
      SecurityGroupId: securityGroups.outputs.bastion,
      SubnetId: subnets.outputs.publicOneId,
      ZoneId: '${zone_id}',
      DnsName: '${bastion_dns_name}',
    },
  },
  outputs: {
  },
};

local vpn = {
  stack:: {
    name: 'svc-vpn-${environment}',
    template_path: './services/vpn/template.yaml',
    enabled: true,
    variables: {
      SecurityGroupId: securityGroups.outputs.vpn,
      SubnetId: subnets.outputs.publicTwoId,
      ZoneId: '${zone_id}',
      DnsName: '${vpn_dns_name}',
    },
  },
  outputs: {
  },
};

local playground = {
  stack:: {
    name: 'svc-playground-${environment}',
    template_path: './services/playground/template.yaml',
    enabled: true,
    variables: {
      PlaygroundSecurityGroupId: securityGroups.outputs.playground,
      ElbSecurityGroupId: securityGroups.outputs.elb,
      SubnetId: subnets.outputs.privateOneId,
      ZoneId: '${zone_id}',
      DnsName: '${playground_dns_name}',
    },
  },
  outputs: {},
};

local efs = {
  stack:: {
    name: 'efs-${environment}',
    template_path: './storage/efs/template.yaml',
    enabled: true,
    variables: {
      Namespace: '${namespace}-${environment}-${region}',
      PlaygroundSubnetId: playground.stack.variables.SubnetId,
      PlaygroundFileSystemSecurityGroupId: securityGroups.outputs.efs,
      PlaygroundFileSystemDnsName: '${playground_efs_dns_name}',
      ZoneId: '${zone_id}',
    },
  },
  outputs:: {
    playgroundDnsName:: '${output efs-${environment}::PlaygroundFileSystemDnsName}',
  },
};

{
  namespace: '${namespace}',
  environment: '${environment}',
  region: '${region}',
  stacker_bucket: '${stacker_bucket_name}',
  stacks: [
    vpc.stack,
    subnets.stack,
    gateways.stack,
    routes.stack,
    roles.stack,
    securityGroups.stack,
    bastion.stack,
    vpn.stack,
    playground.stack,
    efs.stack,
  ],
}
