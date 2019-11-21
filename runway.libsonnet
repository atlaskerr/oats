{
  ignore_git_branch: false,
  tests: [],
  deployments: [{
    modules: [{
      name: 'oats-module',
      path: './core.cfn',
    }],
    regions: ['us-east-1'],
  }],
}
