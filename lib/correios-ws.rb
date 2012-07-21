# -*- encoding : utf-8 -*-
module Correios
  class CalcPrecoPrazo
    attr_accessor(:nCdEmpresa,
                  :sDsSenha, 
                  :nCdServico,
                  :nCdServico,
                  :nCdServico,
                  :sCepOrigem,
                  :sCepDestino,
                  :nVlPeso,
                  :nCdFormato,
                  :nVlComprimento,
                  :nVlAltura,
                  :nVlLargura,
                  :nVlDiametro,
                  :sCdMaoPropria,
                  :nVlValorDeclarado,
                  :sCdAvisoRecebimento)
    def initialize
      yield self if block_given?
    end
  end

  module Servicos
    PAC_SEM_CONTRATO                 = '41106'
    PAC_COM_CONTRATO                 = '41068'
    SEDEX_SEM_CONTRATO               = '40010'
    SEDEX_A_COBRAR_SEM_CONTRATO      = '40045'
    SEDEX_A_COBRAR_COM_CONTRATO      = '40126'
    SEDEX_10_SEM_CONTRATO            = '40215'
    SEDEX_HOJE_SEM_CONTRATO          = '40290'
    SEDEX_COM_CONTRATO_1             = '40096'
    SEDEX_COM_CONTRATO_2             = '40436'
    SEDEX_COM_CONTRATO_3             = '40444'
    SEDEX_COM_CONTRATO_4             = '40568'
    SEDEX_COM_CONTRATO_5             = '40606'
    ESEDEX_COM_CONTRATO              = '81019'
    ESEDEX_PRIORITARIO_COM_CONTRATO  = '81027'
    ESEDEX_EXPRESS_COM_CONTRATO      = '81035'
    GRUPO_1_ESEDEX_COM_CONTRATO      = '81868'
    GRUPO_2_ESEDEX_COM_CONTRATO      = '81833'
    GRUPO_3_ESEDEX_COM_CONTRATO      = '81850'
    ALL = [
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
    ]
  end

  class PackageData
    attr_accessor :peso, :formato, :comprimento, :altura, :largura, :diametro, :valor_declarado, :mao_propria, :aviso_recebimento

    FORMATS = { :box => 1, :roll => 2, :envelope => 3 }

    def initialize
      @peso, @formato, @comprimento, @altura, @largura, @diametro, @valor_declarado, @mao_propria, @aviso_recebimento = '', FORMATS[:box], '', '', '', '', '', '', ''
      yield self if block_given?
    end
  end

  class ShippingCalculator
    require 'soap/wsdlDriver'

    WSDL_URL = 'http://ws.correios.com.br/calculador/CalcPrecoPrazo.asmx?WSDL'

    def initialize codigo_empresa, senha
      @codigo_empresa, @senha = codigo_empresa, senha
      @wsdl_client = wSDLDriverFactory = SOAP::WSDLDriverFactory.new( WSDL_URL ).create_rpc_driver
    end

    def calculate cep_origem, cep_destino, pacote, servicos
      calcPrecoPrazo = CalcPrecoPrazo.new do |o|
        o.nCdEmpresa = @codigo_empresa
        o.sDsSenha = @senha
        o.nCdServico = servicos.collect{|s| s.to_s }.join(',')
        o.sCepOrigem = cep_origem
        o.sCepDestino = cep_destino

        #Package Informations
        o.nVlPeso = pacote.peso
        o.nCdFormato = pacote.formato
        #Dimensions
        o.nVlComprimento = pacote.comprimento
        o.nVlAltura = pacote.altura
        o.nVlLargura = pacote.largura
        o.nVlDiametro = pacote.diametro
        # other options
        o.sCdMaoPropria = pacote.mao_propria ? 'S' : 'N'
        o.nVlValorDeclarado = pacote.valor_declarado
        o.sCdAvisoRecebimento = pacote.aviso_recebimento ? 'S' : 'N'
      end

      return Result.new(@wsdl_client.CalcPrecoPrazo(calcPrecoPrazo))
    end
  end

  class Service
    attr_accessor(:codigo,
                  :valor,
                  :valor_mao_propria,
                  :valor_aviso_recebimento,
                  :valor_declarado,
                  :prazo_entrega,
                  :entrega_domiciliar,
                  :entrega_sabado,
                  :valor_mao_propria,
                  :error,
                  :msg_error)

    def initialize
      yield self if block_given?
    end
  end

  class Result
    def initialize soap_result
      @soap_result = soap_result
    end

    def soap_result
      @soap_result
    end

    def services
      results = Hash.new

      @soap_result.calcPrecoPrazoResult['Servicos']['cServico'].each do |cservico|
        results[cservico['Codigo'].to_s] = Service.new do |s|
          s.codigo = cservico['Codigo']
          s.valor = cservico['Valor']
          s.prazo_entrega = cservico['PrazoEntrega']
          #Dados adicionais Valor
          s.valor_mao_propria = cservico['ValorMaoPropria']
          s.valor_aviso_recebimento = cservico['ValorAvisoRecebimento']
          s.valor_declarado = cservico['ValorDeclarado']
          #Dados adicionais entrega
          s.entrega_domiciliar = cservico['EntregaDomiciliar']
          s.entrega_sabado = cservico['EntregaSabado']
          #Informacoes de Erro
          s.error = cservico['Erro'] == 1
          s.msg_error = cservico['MsgErro']
        end
      end

      results
    end
  end
end