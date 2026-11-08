##############################################
####### Aula CE2 - Prof. Thais         #######
#######       IF STATEMENT             #######
##############################################

## Exemplo 1
x <- 1:5
x <- x - mean(x)
x

if(mean(x)!=0){
  x/mean(x)
}else{
  x/(mean(x)+.00000001)
}


## Exemplo 2
# observe a diferença entre stop/print/warning
if(mean(x)!=0){
  x/mean(x)
}else{
  # stop("A variável x tem média zero.") 
   warning("Média não pode ser zero.")
  # stop("warning ...")
  x/(mean(x)+.000000000001)
}


## Note que o "else" pode ser opcional
if(mean(x)==0){
  x + 0.00000001
}
x/mean(x)



## exemplo 3: Erro
x <- c(1,2,3)

if(x>0){
  x/mean(x)
}else{
  stop()
}


if(mean(x)>0){
  x/mean(x)
}else{
  stop()
}


if(all(x>0)){
  sqrt(x)
}else{
  stop()
}



## Combine multiple logical expressions
# ||, &&, any, all, == , near
x <- 1:10
y <- -1:-10
mean(x)>0
mean(y)>0

mean(x)>0 || mean(y)>0 # OU não vetorizado
mean(x)>0 | mean(y)>0 # OU vetorizado (elemento a elemento)

x>0 || mean(y)>0 # OU não vetorizado: ERRO pois || não é vetorizada
x>0 | mean(y)>0 # OU vetorizado (elemento a elemento)

if(mean(x)>0 || mean(y)>0){
  sqrt(x)
}else{
  stop("warning ...")
}


if(mean(x)>0 && mean(y)>0){
  sqrt(x)
}else{
  stop("warning mean(x)< 0 or mean(y)< 0")
}



## Short if statement that can fit on one line
if(all(x>0)){
  sqrt(x)
} else {"warning"}

if(all(x>0)) sqrt(x) else "warning"


## Obs: Cuidado com representação numérica
library(tidyverse)
y <- 2
z <- sqrt(2)^2
y==z
print(z, digits = 22)


if(y==z){ #evitar esse código e utilizar NEAR
  
}
near(y,z)
?near
near(2, 1.9999999)
near(2, 1.9999999, tol=0.001)
.Machine$double.eps^0.5




## Write multiple conditions
if (this) {
  # do that
} else if (that) {
  # do something else
}else {
  # 
}


x= -3
if(x<0){
  0
}else if(x==Inf){
  10^5
}else{
  x  
}


## case_when
?case_when

x= 3
case_when(
  x<0 ~ 0,
  x==Inf ~ 10^5,
  .default= x
)





## Exercise
# Write a greeting function that says “good morning”, 
# “good afternoon”, or “good evening”, depending on 
# the time of day. (Hint: use a time argument that 
# defaults to lubridate::now().)
library(tidyverse)
library(lubridate)
lubridate::now()

?am
?pm
am(now())
pm(now())


library(lubridate)
library(hms)

greet <- function(time = now()){
  if (am(time)) {
    "good morning"
  }else if (lubridate::hour(time)<18) {
    "good afternoon"
  }else{
    "good evening"
  }
}

greet()
greet(time = hms::hms(0,0,13))
greet( time = hms::hms(0,0,18))
greet( time = hms::hms(0,0,2))
greet( time = hms::hms(0,0,12))



greet <- function(time = now()){
  if( )
  case_when( 
    am(time) ~ "good morning",
    lubridate::hour(time)<18 ~ "good afternoon",
    .default = "good evening"
  )
}

greet()
greet(time = "10")
greet( time = hms::hms(0,0,18))
greet( time = hms::hms(0,0,2))
greet( time = hms::hms(0,0,12))

# Exercise 2: Acrescente uma mensagem de aviso caso o usuário não informe a entrada de forma correta.


## ifelse: vector condition
?ifelse
?if_else

x <- -2:20
x
ifelse(x>0, x^2, -x^2)
if_else(x>0, x^2, -x^2)
mean(x)

ifelse(mean(x)>0, mean(x), -mean(x)) # be careful
ifelse(mean(x)>0, x^2, -x^2) # be careful
if_else(mean(x)>0, x^2, -x^2) # be careful

