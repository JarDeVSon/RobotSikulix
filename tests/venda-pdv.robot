* Settings *
Documentation       Suite de teste de venda no PDV

Resource        ..//resources//base.robot

Test Setup   Inicia Sessão
Suite Setup    Start Sikuli Process
Suite Teardown  Encerrar Sessão
Test Teardown   Finaliza Teste

* Test Cases *


Vender apenas uma cocacola em lata

    Abrir PDV
    Selecionar o Funcionario        func-fernando
    Adicionar um Item               produto-cocacola    1
    Finalizar a Venda
    Deve fechar o pedido com sucesso    
