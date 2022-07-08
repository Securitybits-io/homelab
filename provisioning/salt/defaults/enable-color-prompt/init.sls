/root/.bashrc:
  file.replace:
    - pattern: '#force_color_prompt.*'
    - repl: force_color_prompt=yes