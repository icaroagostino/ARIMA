#################################################################
## Script desenvolvido por Ícaro Agostino e Cristiane Melchior ##
#### Email: icaroagostino@gmail.com / crmelchior@gmail.com ######
#################################################################

#Junho/2018

rm(list=ls()) #Limpando a memoria

########################
# chamando bibliotecas #
########################

library(tseries) #Manipular ST (Trapletti and Hornik, 2017)
library(TSA) #Manipular ST (Chan and Ripley, 2012)
library(lmtest) #Test. Hip. mod. lin. (Zeileis and Hothorn, 2002)
library(forecast) #Modelos de previsão (Hyndman and Khandakar, 2008)
library(ggplot2) #Elegant Graphics (Wickham, 2009)
#library(ggfortify) #Manipular graf. (ST) (Horikoshi and Tang, 2016)

#Obs.:   a biblioteca 'ggfortify' é opcional, ela permite
        #manipular melhor 'autoplot' para dados tipo ST.

########################
### Importando dados ###
########################

# Você precisa definir o diretório onde estão os dados,
# Uma forma simples é usar o atalho "Ctrl + Shift + H"

# a forma mas simples importar dados é através de um txt,
# substitua o nome do arquivo no comando abaixo mantendo a
# extenção ".txt"

dados <- read.table("arquivo.txt", header=T) #lendo banco
attach(dados) #tranformando em objeto

# O primeiro argumento da função 'ts' é o nome da variável no
# banco importado

# start = data da primeira observação
# frequency = 1  (anual)
# frequency = 4  (trimestral)
# frequency = 12 (mensal)
# frequency = 52 (semanal)

x <- ts(x, start = , frequency = ) #tranformando em ST

###################################################
### Seguindo a metodologia Box & Jenkins (1970) ###
###################################################

############################
## Etapa 1: Identificação ##
############################

# Inspeção visual

autoplot(x) + xlab("frequencia") + ylab("Nome da variável")

# Testes de raiz unitaria

# para verificação da estacionariedade é sugeredido o teste Kpss

# Hipotese nula: a série é estacionária
kpss.test(x)

# Se identificado não estacionariedade aplicar diferença
# e repetir o teste

# verificação da autocorrelaçao (acf)
# e aucorrelaçao parical (pacf)

ggtsdisplay(x) #ST + acf + pacf
ggAcf(x) #função de autocorrelação
ggPacf(x) #função de autocorrelação parcial

########################
## Etapa 2: Estimação ##
########################

# para a estimação dos parametros e ajuste do modelo
# será utilizado a função auto.arima(), que utiliza o algoritimo
# desenvolvido e publicado por Hyndman e Khandakar (2008)
# que combina a aplicação de testes de raízes unitarias,
# minimização do AIC e MLE utilizado o procedimento stepwise

ARIMA_auto <- auto.arima(x)
ARIMA_auto #sai o modelo ajustado

# Obs.: alguns autores sugerem não utilizar o nível de sig.
# como critério de inclusão de parâmetros

# caso queira saber a sig dos modelos:
coeftest(ARIMA_auto) #sai a sig. dos coeficientes (p-value)

# Estimação manual (ARIMA(p,d,q)):

# ARIMA_manual <- Arima(x, order = c(1,0,0))

# Obs: informe os parâmetros a serem estimados no argumento order
# Lembrando que é possivel estimar diversos modelos concorrentes
# E decidir o melhor modelo pelos critérios de AIC e BIC

###################################################
## Etapa 3: Validação (Verificação dos residuos) ##
###################################################

# Verificar se os residuos são independentes (x)

checkresiduals(forecast(ARIMA_auto)) #resid + ACF + Hist

# Verificar os residuos padronizados (x)

autoplot(rstandard(ARIMA_auto)) +
  geom_hline(yintercept = 2, lty=3) +
  geom_hline(yintercept = -2, lty=3) +
  geom_hline(yintercept = 3, lty=2, col="4") +
  geom_hline(yintercept = -3, lty=2, col="4")

#######################
## Etapa 4: previsão ##
#######################

# Nessa etapa é definido o horizonte de previsão (h)

print(forecast(ARIMA_auto, h = ))
autoplot(forecast(ARIMA_auto, h = ))
accuracy(forecast(ARIMA_auto)) #periodo de treino

# Como referência para maiores detalhes sobre diversos 
# aspesctos relacionados a previsão fica como sugestão
# o livro 'Forecast principles and practice' (Hyndman e 
# Athanasopoulos, 2018) o primeiro autor do livro é 
# também criador do pacote 'forecast' utilizado neste
# script e o livro pode ser lido online gratuitamente
# em: https://otexts.org/fpp2/index.html
