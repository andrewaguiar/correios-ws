# correios-ws

correios-ws uses correios web-services SOAP to calculate shipping.

## Installation

Add this line to your application's Gemfile:
```shell
	gem 'correios-ws'
```
And then execute:
```shell
	bundle
```
Or install it yourself as:
```shell
	gem install correios-ws
```
## Usage
```ruby
require 'correios-ws'

calculator = Correios::ShippingCalculator.new(codigo_empresa, senha)

package_data = Correios::PackageData.new do |p|
  p.peso = '0.650'
  p.comprimento = '45'
  p.altura = '45'
  p.largura = '45'
end

 calculator.calculate(cep_origem, cep_destino, package_date, array_with_services)
result = calculator.calculate('08061-430','08061-456', package_data, [
      Correios::Servicos::PAC_SEM_CONTRATO,
      Correios::Servicos::PAC_COM_CONTRATO,
      Correios::Servicos::SEDEX_SEM_CONTRATO,
      Correios::Servicos::SEDEX_A_COBRAR_SEM_CONTRATO,
      Correios::Servicos::SEDEX_A_COBRAR_COM_CONTRATO,
      Correios::Servicos::SEDEX_10_SEM_CONTRATO,
      Correios::Servicos::SEDEX_HOJE_SEM_CONTRATO,
      Correios::Servicos::SEDEX_COM_CONTRATO_1,
      Correios::Servicos::SEDEX_COM_CONTRATO_2,
      Correios::Servicos::SEDEX_COM_CONTRATO_3,
      Correios::Servicos::SEDEX_COM_CONTRATO_4,
      Correios::Servicos::SEDEX_COM_CONTRATO_5,
      Correios::Servicos::ESEDEX_COM_CONTRATO,
      Correios::Servicos::ESEDEX_PRIORITARIO_COM_CONTRATO,
      Correios::Servicos::ESEDEX_EXPRESS_COM_CONTRATO, 
      Correios::Servicos::GRUPO_1_ESEDEX_COM_CONTRATO,
      Correios::Servicos::GRUPO_2_ESEDEX_COM_CONTRATO,
      Correios::Servicos::GRUPO_3_ESEDEX_COM_CONTRATO
])
# OR
# result = calculator.calculate('08054-550','09051-456', package_data, Correios::Servicos::ALL)

# services is a Hash with each result
services = result.services

# to get a particular service use the contants in
#     Correios::Servicos
#
# Example:
pac_sem_contrato                = services[Correios::Servicos::PAC_SEM_CONTRATO]
pac_com_contrato                = services[Correios::Servicos::PAC_COM_CONTRATO]
sedex_sem_contrato              = services[Correios::Servicos::SEDEX_SEM_CONTRATO]
sedex_a_cobrar_sem_contrato     = services[Correios::Servicos::SEDEX_A_COBRAR_SEM_CONTRATO]
sedex_a_cobrar_com_contrato     = services[Correios::Servicos::SEDEX_A_COBRAR_COM_CONTRATO]
sedex_10_sem_contrato           = services[Correios::Servicos::SEDEX_10_SEM_CONTRATO]
sedex_hoje_sem_contrato         = services[Correios::Servicos::SEDEX_HOJE_SEM_CONTRATO]
sedex_com_contrato_1            = services[Correios::Servicos::SEDEX_COM_CONTRATO_1]
sedex_com_contrato_2            = services[Correios::Servicos::SEDEX_COM_CONTRATO_2]
sedex_com_contrato_3            = services[Correios::Servicos::SEDEX_COM_CONTRATO_3]
sedex_com_contrato_4            = services[Correios::Servicos::SEDEX_COM_CONTRATO_4]
sedex_com_contrato_5            = services[Correios::Servicos::SEDEX_COM_CONTRATO_5]
esedex_com_contrato             = services[Correios::Servicos::ESEDEX_COM_CONTRATO]
esedex_prioritario_com_contrato = services[Correios::Servicos::ESEDEX_PRIORITARIO_COM_CONTRATO]
esedex_express_com_contrato     = services[Correios::Servicos::ESEDEX_EXPRESS_COM_CONTRATO]
grupo_1_esedex_com_contrato     = services[Correios::Servicos::GRUPO_1_ESEDEX_COM_CONTRATO]
grupo_2_esedex_com_contrato     = services[Correios::Servicos::GRUPO_2_ESEDEX_COM_CONTRATO]
grupo_3_esedex_com_contrato     = services[Correios::Servicos::GRUPO_3_ESEDEX_COM_CONTRATO]

# for each service use its methods
puts esedex_com_contrato.codigo
puts esedex_com_contrato.descricao
puts esedex_com_contrato.valor
puts esedex_com_contrato.valor_mao_propria
puts esedex_com_contrato.valor_aviso_recebimento
puts esedex_com_contrato.valor_declarado
puts esedex_com_contrato.prazo_entrega
puts esedex_com_contrato.entrega_domiciliar
puts esedex_com_contrato.entrega_sabado
puts esedex_com_contrato.erro?
puts esedex_com_contrato.msg_erro

# Searching by CEP

address = Correios::get_address(cep)
puts address.rua
puts address.bairro
puts address.cidade
puts address.estado
puts address.cep
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request