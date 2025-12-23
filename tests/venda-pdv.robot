* Settings *
Documentation       Suite de teste de venda no PDV

Resource        ${EXECDIR}\\resources\\base.robot

Test Setup   Inicia Sessão
Suite Teardown  Encerrar Sessão
Test Teardown   Finaliza Teste

* Test Cases *
Vender o melhor combo
    Abrir PDV
    Selecionar o Funcionario        func-fernando
    Adicionar um Item               produto-coxinha     1
    Adicionar um Item               produto-cocacola    1
    Finalizar a Venda
    Deve fechar o pedido com sucesso

Vender apenas uma cocacola
    Abrir PDV
    Selecionar o Funcionario        func-fernando
    Adicionar um Item               produto-cocacola    1
    Finalizar a Venda
    Deve fechar o pedido com sucesso    
