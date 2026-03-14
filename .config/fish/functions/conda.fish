function conda --description "Run conda without startup auto-activation"
    set -l _hb_conda_exe "$HOME/Private/hummingbot/.miniforge3/bin/conda"
    if set -q HB_CONDA_EXE
        set _hb_conda_exe "$HB_CONDA_EXE"
    end

    if not test -x "$_hb_conda_exe"
        echo "conda executable not found: $_hb_conda_exe" >&2
        return 127
    end

    if test (count $argv) -lt 1
        "$_hb_conda_exe"
        return $status
    end

    set -l _hb_conda_cmd $argv[1]
    set -e argv[1]

    switch $_hb_conda_cmd
        case activate deactivate
            eval ("$_hb_conda_exe" shell.fish $_hb_conda_cmd $argv)
        case install update upgrade remove uninstall
            "$_hb_conda_exe" $_hb_conda_cmd $argv
            and eval ("$_hb_conda_exe" shell.fish reactivate)
        case '*'
            "$_hb_conda_exe" $_hb_conda_cmd $argv
    end
end
