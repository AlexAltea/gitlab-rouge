# gitlab-rouge

Static syntax highlighting for custom languages in GitLab CE/EE installations via Rouge hot-patching.

**Simply a proof-of-concept project. Not affiliated with GitLab in any way. Execute at your own risk.**

## Usage

Install [Rouge](https://github.com/rouge-ruby/rouge), then run the following command:

```bash
$ rougify -r ./lexers/mylang.rb <path/to/script.mylang>
```

## Installation in GitLab

Run the following command:

```bash
$ sudo ./install-gitlab.sh
```

Although both the installer script and GitLab perform checks when dealing with Rouge, there are risks when patching a GitLab installation. Additionally, restarting GitLab incurs in few seconds of downtime.

Uninstall the patched lexers via:

```bash
$ sudo ./install-gitlab.sh --remove
```

## Testing

Run the following command:

```
$ ./test.sh rougify
```
