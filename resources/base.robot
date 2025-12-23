* Settings *
Documentation       Tudo deve começar por aqui

Library         SikuliLibrary    mode=OLD    timeout=10
Library         Process
Resource        actions/pdv.robot

* Keywords *
Carrega os Elementos do App
    ${app_dir}=    Set Variable    ${EXECDIR}//app
    ${proc}=    Start Process
    ...    BugBakery.exe
    ...    cwd=${app_dir}
    ...    shell=True
    Wait Until Keyword Succeeds    
    ...    1 min    
    ...    5 sec    
    ...    Exists    menu-vendas.png
    Add Image Path    ${EXECDIR}//resources//elements

Inicia Sessão
    Carrega os Elementos do App
    

Encerrar Sessão
    Stop Remote Server

Finaliza Teste
    Capture Screen
    Close Application       BugBakery