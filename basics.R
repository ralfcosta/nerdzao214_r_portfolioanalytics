#operacoes basicas
7 + 4
7 - 4
7 / 2
7 * 2

#funcoes artimeticas
log2(4)
abs(-4)
sqrt(4)

#atribuindo valores as variaveis
my_age <- 28
my_age

my_name <- "Nicolas"
my_name

is_datascientist <- TRUE
is_datascientist

#vetores
friend_ages <- c(27, 25, 29, 26)
mean(friend_ages)
max(friend_ages)
length(friend_ages)
sort(friend_ages)
friend_ages * 2

#matrizes e tabelas
friend_ages <- c(27, 25, 29, 26)
friend_names <- c("Joao", "Jose", "Maria", "Roberta")
friend_matrix <- cbind(as.matrix(friend_names),as.matrix(friend_ages))
friend_matrix

friend_table <- as.data.frame(friend_matrix)
str(friend_table)
levels(friend_table$V1)
levels(friend_table$V2)

friend_table <- as.data.frame(friend_matrix, stringsAsFactors = F)
str(friend_table)
as.numeric(friend_table[,2]) * 2

#listas
my_family <- list(
  mother = "Veronica", 
  father = "Rafael",
  sisters = c("Alice", "Monica"),
  sister_age = c(12, 22)
)
my_family
my_family$mother
