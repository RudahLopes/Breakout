programa
{
	inclua biblioteca Graficos-->g
	inclua biblioteca Teclado-->t
	inclua biblioteca Util-->u
	inclua biblioteca Texto-->tex
	inclua biblioteca Sons --> s
		inteiro posicao_horizontal_barrinha = 350, posicao_vertical_barrinha = 520
		inteiro altura_barrinha = 15, largura_barrinha = 100
		real posicao_horizontal_bolinha = 400, posicao_vertical_bolinha = 460
		inteiro tela_inicial = 0, carregar_jogar_novamente = 0
		// x, y, visivel
		inteiro matriz_blocos[42][3] = {{20,50, 1}, 
								{130,50, 1},
								{240,50, 1},
								{350,50, 1},
								{460,50, 1},
								{570,50, 1},
								{680,50, 1},
								{20,100, 1},
								{130,100, 1},
								{240,100, 1},
								{350,100, 1},
								{460,100, 1},
								{570,100, 1},
								{680,100, 1},
								{20,150, 1},
								{130,150, 1},
								{240,150, 1},
								{350,150, 1},
								{460,150, 1},
								{570,150, 1},
								{680,150, 1},
								{20,200, 1},
								{130,200, 1},
								{240,200, 1},
								{350,200, 1},
								{460,200, 1},
								{570,200, 1},
								{680,200, 1},
								{20,250, 1},
								{130,250, 1},
								{240,250, 1},
								{350,250, 1},
								{460,250, 1},
								{570,250, 1},
								{680,250, 1},
								{20,300, 1},
								{130,300, 1},
								{240,300, 1},
								{350,300, 1},
								{460,300, 1},
								{570,300, 1},
								{680,300, 1}}
		logico bolinha_subindo = verdadeiro
		logico movimentar_bolinha_esquerda = verdadeiro
		//armazena o estado atual do jogo. 0 - não iniciado. 1 - Jogando. 2 - pausado
		inteiro estado_atual = 0
		inteiro derrota = 0, vitoria = 0, pause = 0
		inteiro chances = 3
		inteiro tocar_morte = 0, game_intro = 0, perder_vida = 0, tocar_vitoria = 0, tocar_pause = 0, som_ambiente = 0
		logico pausado = falso
		
	funcao inicio()
	{
		criar_blocos()
		iniciar()
		tocar_intro()
		jogar()
	}
	
	funcao iniciar(){
		se (estado_atual == 0){
			tela_inicial=g.carregar_imagem("breakout1.png")
			g.iniciar_modo_grafico (verdadeiro)
			g.definir_dimensoes_janela(800, 600)
			g.definir_titulo_janela("                                                                                                                   BREAKOUT")
			g.desenhar_imagem(1, 1, tela_inicial)
			g.renderizar()
		}
	}
	
	funcao tocar_intro(){
		game_intro = s.carregar_som("game_intro.wav")
		s.reproduzir_som(game_intro, verdadeiro)
	}
	
	funcao tocar_ambiente(){
		som_ambiente = s.carregar_som("tema.mp3")
		s.reproduzir_som(som_ambiente, verdadeiro)
	}
	
	funcao jogar(){
		//Refatorar o código para deixar somente um enquanto
		//enquanto (t.ler_tecla() == t.TECLA_ENTER)
		se (t.ler_tecla() == (t.TECLA_ENTER) e estado_atual == 0 e pausado == falso){
			estado_atual = 1
			s.interromper_som(game_intro)
			som_ambiente = s.carregar_som("tema.mp3")
			s.reproduzir_som(som_ambiente, verdadeiro)
			enquanto(nao t.tecla_pressionada(t.TECLA_ESC)){
				g.definir_cor(g.COR_BRANCO)
				g.desenhar_linha(350,520,350, 535)
				g.desenhar_linha(400, 460, 420, 460)
				escrever_vidas()
				escrever_pause()
				criar_barra()
				desenhar_bolinha()
				criar_blocos()
				destruir_blocos()
				limite_tela()	
				contar_vidas()
				pausar()
				g.renderizar()
			
			}
		}
		se (t.ler_tecla() == (t.TECLA_ESC)){
			g.fechar_janela()
		}
		tecla_invalida()	
}
	
	funcao criar_barra(){
		desenhar_barra()
		movimentar_barra()
	}
	
	funcao desenhar_barra(){
		g.definir_cor(g.COR_VERDE)	
		g.desenhar_retangulo (posicao_horizontal_barrinha, posicao_vertical_barrinha, largura_barrinha, altura_barrinha, falso, verdadeiro)
	}
	
	funcao movimentar_barra(){
		
		se(t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)){
			posicao_horizontal_barrinha--
			se(posicao_horizontal_barrinha==5){
				posicao_horizontal_barrinha= 6
			}
		}
		se(t.tecla_pressionada(t.TECLA_SETA_DIREITA)){
			posicao_horizontal_barrinha++
			se(posicao_horizontal_barrinha==695){
				posicao_horizontal_barrinha= 694
			}
		}
		

	}
	
	funcao desenhar_bolinha(){
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_elipse(posicao_horizontal_bolinha, posicao_vertical_bolinha, 20, 20, verdadeiro)
		movimentar_bolinha()
		
	}
	
	funcao movimentar_bolinha(){
		//Identificar barra
		se(posicao_vertical_bolinha == posicao_vertical_barrinha - 15 e posicao_horizontal_bolinha <= posicao_horizontal_barrinha + 100  e posicao_horizontal_bolinha >= posicao_horizontal_barrinha ou posicao_vertical_bolinha == posicao_vertical_barrinha e posicao_horizontal_bolinha <= posicao_horizontal_barrinha e posicao_horizontal_bolinha >= posicao_horizontal_barrinha){
			bolinha_subindo = verdadeiro
		} 
		//Identificar lado esquerdo da barra
		se(posicao_horizontal_bolinha + 20 == posicao_horizontal_barrinha e posicao_vertical_bolinha <= posicao_vertical_barrinha + 15 e posicao_vertical_bolinha >= posicao_vertical_barrinha){
			movimentar_bolinha_esquerda = verdadeiro
		}
		//Identificar lateral da barra base esquerda
		se (posicao_horizontal_bolinha == posicao_horizontal_barrinha e posicao_vertical_bolinha == posicao_vertical_barrinha){
			movimentar_bolinha_esquerda = verdadeiro
		}
		//Identificar lado direito da barra
		se(posicao_horizontal_bolinha == posicao_horizontal_barrinha + 100 e posicao_vertical_bolinha <= posicao_vertical_barrinha + 15 e posicao_vertical_bolinha >= posicao_vertical_barrinha){
			movimentar_bolinha_esquerda = falso
		}
		
		//Identificar lateral da barra base direita
		se (posicao_horizontal_bolinha == posicao_horizontal_barrinha + 100 e posicao_vertical_bolinha == posicao_vertical_barrinha){
			movimentar_bolinha_esquerda = falso
		}
		//Identificar topo
		se (posicao_vertical_bolinha <= 11) {
			bolinha_subindo = falso	
		}
		//Identificar limite direito da tela
		se(posicao_horizontal_bolinha >= 780){
			movimentar_bolinha_esquerda = verdadeiro
		}
		//Identificar limite esquerdo da tela
		se(posicao_horizontal_bolinha <= 11){
			movimentar_bolinha_esquerda = falso
		}
		
		movimentar_bolinha_verticalmente()
		movimentar_bolinha_horizontalmente()
	}
	
	funcao movimentar_bolinha_verticalmente(){
		se(bolinha_subindo == verdadeiro){
			//posicao_vertical_bolinha--
			posicao_vertical_bolinha = posicao_vertical_bolinha - 0.5
		} senao {
			//posicao_vertical_bolinha++
			posicao_vertical_bolinha = posicao_vertical_bolinha + 0.5
		}	
	}
	
	funcao movimentar_bolinha_horizontalmente(){
		se(movimentar_bolinha_esquerda == verdadeiro){
			//posicao_horizontal_bolinha--
			posicao_horizontal_bolinha = posicao_horizontal_bolinha - 0.5
		} senao {
			//posicao_horizontal_bolinha++
			posicao_horizontal_bolinha = posicao_horizontal_bolinha + 0.5
		}	
	}
	
	funcao limite_tela(){
		limite_tela_topo()
		limite_tela_base()
		limite_tela_direita()
		limite_tela_esquerda()
	}
	
	funcao limite_tela_topo(){
		g.definir_cor(g.COR_AZUL)
		g.desenhar_retangulo (1, 1, 800, 8, verdadeiro, verdadeiro)
		
	}
	
	funcao limite_tela_base(){
		g.definir_cor(g.COR_AZUL)
		g.desenhar_retangulo (1, 591, 800, 8, verdadeiro, verdadeiro)
	}
	
	funcao limite_tela_direita(){
		g.definir_cor(g.COR_AZUL)
		g.desenhar_retangulo(790, 1, 9, 590, verdadeiro, verdadeiro)
	}
	
	funcao limite_tela_esquerda(){
		g.definir_cor(g.COR_AZUL)
		g.desenhar_retangulo(0, 1, 9, 590, verdadeiro, verdadeiro)
	
	}
	
	funcao criar_blocos(){
		desenhar_blocos()
	}
	
	funcao desenhar_blocos(){
		para (inteiro linha = 0; linha<=41; linha++){
			se(matriz_blocos[linha][2] == 1){
				g.definir_cor(g.COR_BRANCO)			
				g.desenhar_retangulo (matriz_blocos[linha][0], matriz_blocos[linha][1], 100, 15, verdadeiro, verdadeiro)
			}	
				
		}
	}
	
	funcao destruir_blocos(){
		destruir_blocos_linha1()
		destruir_blocos_linha2()
		destruir_blocos_linha3()
		destruir_blocos_linha4()
		destruir_blocos_linha5()
		destruir_blocos_linha6()
		analisar_vitoria()
	}
	
	funcao destruir_blocos_linha1(){
		se(matriz_blocos[0][2] == 1){
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = verdadeiro
				matriz_blocos[0][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = falso
				matriz_blocos[0][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 20){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[0][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 120){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[0][2] = 0
			}
		}
		se(matriz_blocos[1][2] == 1){
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = verdadeiro
				matriz_blocos[1][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = falso
				matriz_blocos[1][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 130){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[1][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 230){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[1][2] = 0
			}
		}
		se(matriz_blocos[2][2] == 1){
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = verdadeiro
				matriz_blocos[2][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = falso
				matriz_blocos[2][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 240){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[2][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 340){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[2][2] = 0
			}
		}
		se(matriz_blocos[3][2] == 1){	
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = verdadeiro
				matriz_blocos[3][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = falso
				matriz_blocos[3][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 350){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[3][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 450){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[3][2] = 0
			}
		}
		se(matriz_blocos[4][2] == 1){
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = verdadeiro
				matriz_blocos[4][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = falso
				matriz_blocos[4][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 460){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[4][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 560){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[4][2] = 0
			}
		}
		se(matriz_blocos[5][2] == 1){	
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = verdadeiro
				matriz_blocos[5][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = falso
				matriz_blocos[5][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 570){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[5][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 670){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[5][2] = 0
			}
		}
		se(matriz_blocos[6][2] == 1){
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 35 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = verdadeiro
				matriz_blocos[6][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 50 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = falso
				matriz_blocos[6][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 680){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[6][2] = 0
			}
			se(posicao_vertical_bolinha >= 35 e posicao_vertical_bolinha <= 50 e posicao_horizontal_bolinha == 780){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[6][2] = 0
			}
		}
	}
	
	funcao destruir_blocos_linha2(){
		se(matriz_blocos[7][2] == 1){
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = verdadeiro
				matriz_blocos[7][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = falso
				matriz_blocos[7][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 20){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[7][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 120){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[7][2] = 0
			}
		}
		se(matriz_blocos[8][2] == 1){
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = verdadeiro
				matriz_blocos[8][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = falso
				matriz_blocos[8][2] = 0
			}
			se(posicao_vertical_bolinha >=85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 130){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[8][2] = 0
			}
			se(posicao_vertical_bolinha >=85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 230){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[8][2] = 0
			}
		}
		se(matriz_blocos[9][2] == 1){
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = verdadeiro
				matriz_blocos[9][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = falso
				matriz_blocos[9][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 240){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[9][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 340){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[9][2] = 0
			}
		}
		se(matriz_blocos[10][2] == 1){	
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = verdadeiro
				matriz_blocos[10][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = falso
				matriz_blocos[10][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 350){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[10][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 450){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[10][2] = 0
			}
		}
		se(matriz_blocos[11][2] == 1){
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = verdadeiro
				matriz_blocos[11][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = falso
				matriz_blocos[11][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 460){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[11][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 560){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[11][2] = 0
			}
		}
		se(matriz_blocos[12][2] == 1){	
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = verdadeiro
				matriz_blocos[12][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = falso
				matriz_blocos[12][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 570){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[12][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 670){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[12][2] = 0
			}
		}
		se(matriz_blocos[13][2] == 1){
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 85 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = verdadeiro
				matriz_blocos[13][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 100 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = falso
				matriz_blocos[13][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 680){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[13][2] = 0
			}
			se(posicao_vertical_bolinha >= 85 e posicao_vertical_bolinha <= 100 e posicao_horizontal_bolinha == 780){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[13][2] = 0
			}
		}
	}
	
	funcao destruir_blocos_linha3(){
		se(matriz_blocos[14][2] == 1){
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = verdadeiro
				matriz_blocos[14][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = falso
				matriz_blocos[14][2] = 0
			}
			se(posicao_vertical_bolinha >= 135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 20){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[14][2] = 0
			}
			se(posicao_vertical_bolinha >= 135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 120){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[14][2] = 0
			}
		}
		se(matriz_blocos[15][2] == 1){
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = verdadeiro
				matriz_blocos[15][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = falso
				matriz_blocos[15][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 130){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[15][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 230){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[15][2] = 0
			}
		}
		se(matriz_blocos[16][2] == 1){
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = verdadeiro
				matriz_blocos[16][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = falso
				matriz_blocos[16][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 240){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[16][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 340){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[16][2] = 0
			}
		}
		se(matriz_blocos[17][2] == 1){	
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = verdadeiro
				matriz_blocos[17][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = falso
				matriz_blocos[17][2] = 0
			}
			se(posicao_vertical_bolinha >= 135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 350){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[17][2] = 0
			}
			se(posicao_vertical_bolinha >= 135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 450){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[17][2] = 0
			}
		}
		se(matriz_blocos[18][2] == 1){
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = verdadeiro
				matriz_blocos[18][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = falso
				matriz_blocos[18][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 460){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[18][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 560){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[18][2] = 0
			}
		}
		se(matriz_blocos[19][2] == 1){	
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = verdadeiro
				matriz_blocos[19][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = falso
				matriz_blocos[19][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 570){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[19][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 670){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[19][2] = 0
			}
		}
		se(matriz_blocos[20][2] == 1){
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 135 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = verdadeiro
				matriz_blocos[20][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 150 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = falso
				matriz_blocos[20][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 680){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[20][2] = 0
			}
			se(posicao_vertical_bolinha >=135 e posicao_vertical_bolinha <= 150 e posicao_horizontal_bolinha == 780){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[20][2] = 0
			}
		}
	}
	
	funcao destruir_blocos_linha4(){
		se(matriz_blocos[21][2] == 1){
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = verdadeiro
				matriz_blocos[21][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = falso
				matriz_blocos[21][2] = 0
			}
			se(posicao_vertical_bolinha >= 185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 20){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[21][2] = 0
			}
			se(posicao_vertical_bolinha >= 185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 120){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[21][2] = 0
			}
		}
		se(matriz_blocos[22][2] == 1){
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = verdadeiro
				matriz_blocos[22][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = falso
				matriz_blocos[22][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 130){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[22][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 230){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[22][2] = 0
			}
		}
		se(matriz_blocos[23][2] == 1){
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = verdadeiro
				matriz_blocos[23][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = falso
				matriz_blocos[23][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 240){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[23][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 340){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[23][2] = 0
			}
		}
		se(matriz_blocos[24][2] == 1){	
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = verdadeiro
				matriz_blocos[24][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = falso
				matriz_blocos[24][2] = 0
			}
			se(posicao_vertical_bolinha >= 185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 350){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[24][2] = 0
			}
			se(posicao_vertical_bolinha >= 185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 450){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[24][2] = 0
			}
		}
		se(matriz_blocos[25][2] == 1){
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = verdadeiro
				matriz_blocos[25][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = falso
				matriz_blocos[25][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 460){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[25][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 560){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[25][2] = 0
			}
		}
		se(matriz_blocos[26][2] == 1){	
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = verdadeiro
				matriz_blocos[26][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = falso
				matriz_blocos[26][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 570){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[26][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 670){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[26][2] = 0
			}
		}
		se(matriz_blocos[27][2] == 1){
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 185 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = verdadeiro
				matriz_blocos[27][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 200 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = falso
				matriz_blocos[27][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 680){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[27][2] = 0
			}
			se(posicao_vertical_bolinha >=185 e posicao_vertical_bolinha <= 200 e posicao_horizontal_bolinha == 780){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[27][2] = 0
			}
		}
	}
	
	funcao destruir_blocos_linha5(){
		se(matriz_blocos[28][2] == 1){
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = verdadeiro
				matriz_blocos[28][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = falso
				matriz_blocos[28][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 20){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[28][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 120){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[28][2] = 0
			}
		}
		se(matriz_blocos[29][2] == 1){
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = verdadeiro
				matriz_blocos[29][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = falso
				matriz_blocos[29][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 130){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[29][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 230){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[29][2] = 0
			}
		}
		se(matriz_blocos[30][2] == 1){
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = verdadeiro
				matriz_blocos[30][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = falso
				matriz_blocos[30][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 240){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[30][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 340){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[30][2] = 0
			}
		}
		se(matriz_blocos[31][2] == 1){	
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = verdadeiro
				matriz_blocos[31][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = falso
				matriz_blocos[31][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 350){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[31][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 450){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[31][2] = 0
			}
		}
		se(matriz_blocos[32][2] == 1){
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = verdadeiro
				matriz_blocos[32][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = falso
				matriz_blocos[32][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 460){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[32][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 560){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[32][2] = 0
			}
		}
		se(matriz_blocos[33][2] == 1){	
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = verdadeiro
				matriz_blocos[33][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = falso
				matriz_blocos[33][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 570){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[33][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 670){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[33][2] = 0
			}
		}
		se(matriz_blocos[34][2] == 1){
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 235 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = verdadeiro
				matriz_blocos[34][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 250 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = falso
				matriz_blocos[34][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 680){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[34][2] = 0
			}
			se(posicao_vertical_bolinha >=235 e posicao_vertical_bolinha <= 250 e posicao_horizontal_bolinha == 780){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[34][2] = 0
			}
		}
	}
	
	funcao destruir_blocos_linha6(){
		se(matriz_blocos[35][2] == 1){
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = verdadeiro
				matriz_blocos[35][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 20 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 120){
				bolinha_subindo = falso
				matriz_blocos[35][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 20){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[35][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 120){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[35][2] = 0
			}
		}
		se(matriz_blocos[36][2] == 1){
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = verdadeiro
				matriz_blocos[36][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 130 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 230){
				bolinha_subindo = falso
				matriz_blocos[36][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 130){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[36][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 230){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[36][2] = 0
			}
		}
		se(matriz_blocos[37][2] == 1){
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = verdadeiro
				matriz_blocos[37][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 240 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 340){
				bolinha_subindo = falso
				matriz_blocos[37][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 240){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[37][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 340){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[37][2] = 0
			}
		}
		se(matriz_blocos[38][2] == 1){	
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = verdadeiro
				matriz_blocos[38][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 350 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 450){
				bolinha_subindo = falso
				matriz_blocos[38][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 350){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[38][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 450){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[38][2] = 0
			}
		}
		se(matriz_blocos[39][2] == 1){
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = verdadeiro
				matriz_blocos[39][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 460 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 560){
				bolinha_subindo = falso
				matriz_blocos[39][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 460){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[39][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 560){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[39][2] = 0
			}
		}
		se(matriz_blocos[40][2] == 1){	
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = verdadeiro
				matriz_blocos[40][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 570 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 670){
				bolinha_subindo = falso
				matriz_blocos[40][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 570){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[40][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 670){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[40][2] = 0
			}
		}
		se(matriz_blocos[41][2] == 1){
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 285 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = verdadeiro
				matriz_blocos[41][2] = 0
			} 
			se(posicao_horizontal_bolinha >= 680 e posicao_vertical_bolinha == 300 e posicao_horizontal_bolinha <= 780){
				bolinha_subindo = falso
				matriz_blocos[41][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 680){
				movimentar_bolinha_esquerda = verdadeiro
				matriz_blocos[41][2] = 0
			}
			se(posicao_vertical_bolinha >=285 e posicao_vertical_bolinha <= 300 e posicao_horizontal_bolinha == 780){
				movimentar_bolinha_esquerda = falso
				matriz_blocos[41][2] = 0
			}
		}
	}
	
	funcao escrever_vidas(){
		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(15.0)
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.desenhar_texto(710, 570, "VIDAS: " + chances)
	}
	
	funcao contar_vidas(){
		
		se(posicao_vertical_bolinha >= 780 e posicao_vertical_bolinha <= 800){
			bolinha_subindo = verdadeiro
			movimentar_bolinha_esquerda = verdadeiro
			movimentar_bolinha()
			posicao_vertical_bolinha = 400
			posicao_vertical_bolinha = 460
			movimentar_bolinha()
			chances = chances - 1
			perder_vida = s.carregar_som("derrota.wav")
			s.reproduzir_som(perder_vida, falso)
			
			se (chances == 0){
				s.interromper_som(som_ambiente)
				posicao_vertical_bolinha = 810
				tocar_morte = s.carregar_som("derrotafinal.wav")
				s.reproduzir_som(tocar_morte, falso)
				derrota = g.carregar_imagem("Defeat12.jpg")
				g.desenhar_imagem(150, 360, derrota)
				g.renderizar()
				u.aguarde(2000)
				
				jogar_novamente()
			}
		}
	}	
	
	funcao jogar_novamente(){
		g.limpar()
		carregar_jogar_novamente = g.carregar_imagem("JogarNovamente.png")
		g.desenhar_imagem(1, 1, carregar_jogar_novamente)
		g.renderizar()
		se (t.ler_tecla() == (t.TECLA_ENTER)){
			posicao_horizontal_barrinha = 350
			posicao_vertical_barrinha = 520
			posicao_horizontal_bolinha = 400
			posicao_vertical_bolinha = 430
			bolinha_subindo = verdadeiro
			chances = 3
			s.reproduzir_som(som_ambiente, verdadeiro)
			para(inteiro linha = 0; linha <= 41; linha++){
				matriz_blocos[linha][2] = 1
			}
			jogar()
		}
		se(t.ler_tecla() == (t.TECLA_ESC)){
			g.fechar_janela()				
		}	
		tecla_invalida()			
	}
	
	funcao analisar_vitoria(){
		se (matriz_blocos[0][2] == 0 e matriz_blocos[1][2] == 0 e matriz_blocos[2][2] == 0 e matriz_blocos[3][2] == 0 e matriz_blocos[4][2] == 0 e matriz_blocos[5][2] == 0 e matriz_blocos[6][2] == 0 e matriz_blocos[7][2] == 0 e matriz_blocos[8][2] == 0 e matriz_blocos[9][2] == 0 e matriz_blocos[10][2] == 0 e matriz_blocos[11][2] == 0 e matriz_blocos[12][2] == 0 e matriz_blocos[13][2] == 0 e matriz_blocos[14][2] == 0 e matriz_blocos[15][2] == 0 e matriz_blocos[16][2] == 0 e matriz_blocos[17][2] == 0 e matriz_blocos[18][2] == 0 e matriz_blocos[19][2] == 0 e matriz_blocos[20][2] == 0 e matriz_blocos[21][2] == 0 e matriz_blocos[22][2] == 0 e matriz_blocos[23][2] == 0 e matriz_blocos[24][2] == 0 e matriz_blocos[25][2] == 0 e matriz_blocos[26][2] == 0 e matriz_blocos[27][2] == 0 e matriz_blocos[28][2] == 0 e matriz_blocos[29][2] == 0 e matriz_blocos[30][2] == 0 e matriz_blocos[31][2] == 0 e matriz_blocos[32][2] == 0 e matriz_blocos[33][2] == 0 e matriz_blocos[34][2] == 0 e matriz_blocos[35][2] == 0 e matriz_blocos[36][2] == 0 e matriz_blocos[37][2] == 0 e matriz_blocos[38][2] == 0 e matriz_blocos[39][2] == 0 e matriz_blocos[40][2] == 0 e matriz_blocos[41][2] == 0){			
			s.interromper_som(som_ambiente)
			tocar_vitoria = s.carregar_som("vitoria.wav")
			s.reproduzir_som(tocar_vitoria, falso)
			vitoria = g.carregar_imagem("victory.jpg")
			g.desenhar_imagem(110, 160, vitoria)
			g.renderizar()
			u.aguarde(7000)
			chances = chances + 4
			jogar_novamente()
		}
	}
	
	funcao escrever_pause(){
		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(15.0)
		g.definir_estilo_texto(falso, verdadeiro, falso)
		g.desenhar_texto(17, 570, "PRESSIONE <ESPAÇO> PARA PAUSAR")
	}
	
	funcao pausar(){
		se(t.tecla_pressionada(t.TECLA_ESPACO)){
			pausado = verdadeiro
			posicao_horizontal_bolinha = posicao_horizontal_bolinha
			posicao_vertical_bolinha = posicao_vertical_bolinha
			s.interromper_som(som_ambiente)
			tocar_pause = s.carregar_som("pause_song.wav")
			s.reproduzir_som(tocar_pause, falso)
			enquanto (t.tecla_pressionada(t.TECLA_ESPACO)){
			}
		}
		enquanto(pausado == verdadeiro){
			se(t.tecla_pressionada(t.TECLA_ESPACO)){
				s.reproduzir_som(tocar_pause, falso)
				pausado=falso
				tocar_ambiente()
				enquanto(t.tecla_pressionada(t.TECLA_ESPACO)){
				}
			}	
		}
	}
	
	funcao tecla_invalida(){
		se (nao t.tecla_pressionada(t.TECLA_ENTER) ou nao t.tecla_pressionada(t.TECLA_ESC))  {
			g.definir_cor(g.COR_BRANCO)
			g.definir_tamanho_texto(30.0)
			g.definir_estilo_texto(falso, verdadeiro, falso)
			g.desenhar_texto(220, 250, "APERTAR TECLA VÁLIDA")
			g.renderizar()
			u.aguarde(2000)
			iniciar()
			jogar()
		}
	}
}	
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 43852; 
 * @DOBRAMENTO-CODIGO = [12, 63, 71, 82, 87, 123, 128, 133, 151, 158, 197, 207, 217, 224, 230, 235, 240, 246, 250, 260, 270, 399, 528, 657, 786, 915, 1044, 1051, 1079, 1103];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */