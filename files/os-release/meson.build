project('amelia-os-release')

branch_name = get_option('branch')
if branch_name == '2.0-exp'
  branch_name = 'Nightly'
endif

conf_data = configuration_data({
  'SDK_BRANCH': branch_name
})

if get_option('mode') == 'bootable'
    conf_data.set('ISSUE_NAME', 'Project Amelia')
    conf_data.set('VARIANT_ID', get_option('variant'))
    if get_option('variant') == 'devel'
      conf_data.set('VARIANT', 'Development')
      conf_data.set('FULL_NAME', 'Project Amelia Development')
    elif get_option('variant') == 'user'
      conf_data.set('VARIANT', 'User')
      conf_data.set('FULL_NAME', 'Project Amelia')
    endif

    configure_file(
        input : 'os-release.bootable.in',
        output : 'os-release',
        configuration : conf_data,
        install_dir : get_option('prefix') / 'lib'
    )
endif

configure_file(
   input : 'issue.net.in',
    output : 'issue.net',
    configuration : conf_data,
    install_dir : get_option('sysconfdir')
)

configure_file(
   input : 'issue.in',
    output : 'issue',
    configuration : conf_data,
    install_dir : get_option('sysconfdir')
)

meson.add_install_script('os-release-symlink.sh', get_option('sysconfdir'))