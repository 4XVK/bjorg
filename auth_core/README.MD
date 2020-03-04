#### WIP auth handling

envs, et al, will be stored without dot prefix organized by project dir as managed by bjorg

- storage for project env (eg. ```auth_core/project_name/env```)
- storage for bjorg core auth (eg. ```auth_core/bjorg_auth```)
    - this will include child server auth data for child servers to a controlling bjorg core.
    - should allow for ```../util/``` tools to be used remotely with automation
    - can probably stick with ```foo=bar\n``` format to hack ```user@host``` because we probably don't need much
    more than that.