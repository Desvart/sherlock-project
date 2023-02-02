Procédure allant du tagging des signaux jusqu'à l'application du système de reconnaissance.


1. Tagguer les signaux (T010) 
Le but est de localiser le début de chaque élément d'intérêt dans les tocs en référençant les index des échantillons commençant ces éléments. Les cinq éléments d'intérêt sont les suivants :
	- le dégagement
	- la chute de dégagement
	- l'impulsion
	- la chute d'impulsion
	- la chute
Le script tag_them_all est une interface facilitant le tagging manuel des fichiers d'une sous-base de données.
À l'éxécution, ce script affiche le signal au complet ainsi que le début et la fin de chaque toc du signal. S'il s'avère que ces informations ne sont pas juste pour tous les tocs affichés, l'utilisateur peut modifier les paramètre du script de détection PANDAS en cours de route, sinon il continue l'exécution du script en appuyant sur enter. Les paramètres de PANDAS validés, le script affiche alors un zoom sur le 1er toc du signal. L'utilisateur peut alors tagguer les différents éléments d'intérêt en utilisant l'outil Data Cursor de l'interface Matlab. Pour tagguer de multiple point dans le même affiche, l'utilisateur doit utiliser l'outil Data Cursor tout en maintenant la touche ALT appuyée. Une fois les tags déposés aux endroits souhaités, l'utilisateur retourne dans la Command Window de Matlab et appuye sur enter pour passer au toc suivant. À la fin du signal, le script recommence avec le signal suivant disponible dans la sous-base de données. 
À la fin du dernier signal les tags sont enregistrés dans un fichier .mat. Ce fichier contient deux variables. La première "pandasParamArray" est un tableau de 4 colonnes et de n lignes, n étant le nombre de fichiers de la sous-base de données. Les 4 éléments de chaque ligne correspondent aux paramètres modifiés et validés par l'utilisateur au début de chaque fichier, avant de les tagguer. La deuxième variable "tagArray" contient tous les tags déposés par l'utilisateur. Puisque le nombre de tags peut être variable d'un fichier à l'autre, cette variable est un cell array. Il y a autant de cell que de fichiers dans la sous-base de données. Chaque cell contient un vecteur contenant les index de chaque tags pour le signal considéré.
Attention ! Lors de l'opération de tagging des tocs, il arrivent qu'un évènement d'intérêt ne soit pas tagguable. Ceci peut être dû au fait que l'évènement n'est pas visible sur le signal ou que la configuration du signal ne le rend pas suffisamment distinguable d'un autre élément. Dans ce cas, il faut spécifier, dans un fichier annexe, quel évènement a été "raté". Un fichier excel est utilisé à cette fin. Il s'agit, en général, de l'onglet "Tocs" du fichier excel décrivant la sous-base de données. Cet onglet liste chaque toc de chaque signal et chaque évènement à extraire. Dans le cas où un évènement est manquant, l'utilisateur doit inscrire "n" dans la case qui sera manquante.


2. Sauvegarder les tags dans un fichier excel (T015)
Le script utilise les informations stockées dans l'onglet "Tocs" du fichier excel pour construir un tableau cohérent de tous les tags, valeurs manquantes y comprises. Ce tableau est enregistré dans un autre onglet "Tocs 2".


3. Extraction des caractéristiques d'intérêt (T020)
Ce script est celui permettant d'extraire les caractéstiques jugées intéressantes en se basant sur les délimitations définies par les tags. Il doit être modifié en profondeur si l'on souhaite avoir d'autre caractéristiques.
Ce script sauve les caractéristiques extraites et calculées dans un fichier dataset.mat. Chaque caractéristique est enregistrée, à son nom, dans un tableau à 2 colonnes. La première colonne contient les les caractéristiques pour les tics et la seconde pour les tacs. Vu qu'il n'a pas été possible dans le cadre de ce projet d'identifier clairement qui est tic et qui est tac, cette notion de double colonne importe peu. Le format par contre est à respecter pour la suite des algorithmes.


4. Affichage des dynamiques des caractéristiques (T030)

5. Code de reconnaissance (T040)
