#################################################################
## Script desenvolvido por Ícaro Agostino ##
#### Email: icaroagostino@gmail.com ######
### Disponivél em gi
#################################################################

# quinta 09 de agosto

rm(list=ls()) # limpando memoria

# chamando bibliotecas

library(tseries) #manipular ST
library(forecast) #previsão
library(ggplot2) #graficos
library(lmtest) #teste

# algumas fuções uteis

args(Arima)
help(Arima) # ou f1 em cima da função

# importando dados

banco_imp <- read.table("https://raw.githubusercontent.com/icaroagostino/ARIMA/master/dados/IMP.txt", header = T)
banco_expo <- read.table("https://raw.githubusercontent.com/icaroagostino/ARIMA/master/dados/EXPO.txt", header = T)

attach(banco_imp)
attach(banco_expo)

imp <- ts(IMP, start = 2012, frequency = 12)
exp <- ts(EXPO, start = 2012, frequency = 12)

# Gráficos importação

autoplot(imp)
ggtsdisplay(imp)
ggtsdisplay(imp, main="Importações totais")
ggtsdisplay(imp, plot.type = "histogram")
ggtsdisplay(imp, plot.type = "scatter")

decompose(imp)
autoplot(decompose(imp))
imp %>% decompose %>% autoplot

# estacionariedade

kpss.test(imp)
kpss.test(diff(imp)) # d = 1

adf.test(imp)
adf.test(diff(imp)) # d = 1

autoplot(diff(imp)) + autolayer(imp)

ggtsdisplay(diff(imp))

# separar st

imp_in <- window(imp, start = 2012, end = c(2016,12))
imp_out <- window(imp, start = 2017, end = c(2017,12))

autoplot(imp_in) + autolayer(imp_out)

# Arima

fit1 <- auto.arima(imp_in) # ajuste automatico
fit1 # modelo ajustado
coeftest(fit1) # sig. parametros

fit2 <- Arima(imp_in, order = c(1,1,1), seasonal = c(1,0,0)) # ajuste manual
fit2
coeftest(fit2)

autoplot(fit1) # raízes

checkresiduals(fit1) #resíduos
ggAcf(resid(fit1))
ggPacf(resid(fit1))

autoplot(imp_in) + autolayer(fitted(fit1)) # real x ajustado

library(TSA)
autoplot(rstandard(fit1)) +
  geom_hline(yintercept = 2, lty=3) +
  geom_hline(yintercept = -2, lty=3) +
  geom_hline(yintercept = 3, lty=2, col="4") +
  geom_hline(yintercept = -3, lty=2, col="4")

forecast(fit1, h = 12) # previsão h = 12
forecast(fit1, h = 12) %>% autoplot
autoplot(forecast(fit1, h = 12))

f1 <- forecast(fit1, h = 12) # salvar previsão
autoplot(f1) + autolayer(imp_out) # comparar com real

accuracy(f1) # medidas de erro
accuracy(f1, imp_out)

citation() # citação do R
citation('forecast') # citação dos pacotes
citation('tseries')