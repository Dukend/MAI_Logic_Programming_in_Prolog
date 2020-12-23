# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Кондратьев Е.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |       5       |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

В результате курсового проекта я получу базовые навыки написания программ на логическом языке программирования Prolog, а также смогу в общих чертах познакомиться с логическим программированием и сравнить написание программ на логических и императивных языках программирования.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: 
 `father(отец, потомок)` и `mother(мать, потомок)` (дополнительно `sex(человек, пол)` для пункта 4).
 3. Реализовать предикат проверки/поиска `Тещи`.
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве.
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Мое родословное дерево было создано при помощи сервиса MyHeritage.com, в нем получилось 150 человек. Затем я экспортировал это дерево, с помощью встроенных в сервис функций, и получил файл в формате GEDCOM.

## Конвертация родословного дерева

Для конвертации GEDCOM файла в предикаты Prolog использовался язык Python, так как весь GEDCOM файл имеет свою структуру, крайне просто было вычленить нужную и информацию и преобразовать ее в предикаты. Весь GEDCOM файл состоит из двух частей, первая содержит в себе информацию о вершинах графа, вторая о семьях в графе. 
1. Из файла с расширением .ged считываются строки, и остаются только те, которые содержат поля «NAME», «FAMS», «FAMC» или «SEX».
2. Заполняется массив "семей" `parents([Husb, Wife, Child])`.
3. Из массива создаюся строки в виде `father(отец, потомок)` и `mother(мать, потомок)` (дополнительно `sex(человек, пол)` для пункта 4).
4. Эти строки отправляются в файл data.pl. 
Вот и конец работы парсера.
```python
for line in list:
    if(line.find('INDI', 0, len(line)-1)!=-1):
        word = line.split(' ')
        ID = word[1]
    elif ((line.find('GIVN',0,len(line)-1)!=-1)):
        word = line.split(' ')
        name = word[2].rstrip()
    elif ((line.find('SURN', 0, len(line)-1)!=-1)):
        word = line.split(' ')
        name = name + ' ' + word[2].rstrip()
        person[ID] = name
    elif ((line.find('SEX', 0, len(line)-1)!=-1)):
        word = line.split(' ')
        sex.append([name, word[2].rstrip()])

for line in list:
    if(line.find('HUSB', 0, len(line)-1)!=-1):
        word = line.split(' ')
        husb = person[word[2].rstrip()]
    elif(line.find('WIFE', 0, len(line)-1)!=-1):
        word = line.split(' ')
        wife = person[word[2].rstrip()]
    elif(line.find('CHIL', 0, len(line)-1)!=-1):
        word = line.split(' ')
        parents.append([husb, wife, person[word[2].rstrip()]])

fout = open("data.pl", "w")
for i in parents:
	fout.write('father(\'{}\', \'{}\').\n'.format(i[0],i[2]))
for i in parents:
	fout.write('mother(\'{}\', \'{}\').\n'.format(i[1],i[2]))

for i in sex:
	fout.write('sex(\'{}\', \'{}\').\n'.format(i[0],i[1]))
fout.close()
```


## Предикат поиска родственника

Предикат поиска тещи ищет мужа и жену через их ребенка, затем ищет маму жены, и, таким образом, определяет тещу

Но очень важно, что этот предикат не работает, если нет детей у зятя.
```Prolog
% 3 пункт
% X теща Y
motherinlaw(Motherinlaw, P):-
    father(P, Child),
    mother(Wife, Child),
    mother(Motherinlaw, Wife).
```
```Prolog    
?- motherinlaw(Mil, 'Andrew Dofbysh').
Mil = 'Ludmila Timofeeva'.
```
(Это верный ответ)

## Определение степени родства

Для родственников описываем предикаты родства.
```Prolog 
% X брат Y
brother(X, Y):-
	sex(X, 'M'),
	(	father(Z, X),
		father(Z, Y)
	;	mother(Q, X),
		mother(Q, Y)
	),
	X \= Y.
% X сестра Y
sister(X, Y):-
	sex(X, 'F'),
	(	father(Z, X),
		father(Z, Y)
	;	mother(Q, X),
		mother(Q, Y)
	),
	X \= Y.
% X муж Y
husband(X, Y):-
	father(X, Z),
	mother(Y, Z).
% X жена Y
wife(X, Y):-
	mother(X, Z),
	father(Y, Z).
% X сын Y
son(X, Y):-
	sex(X, 'M'),
	(father(Y, X) ; mother(Y, X)).
% X дочь Y
daughter(X, Y):-
	sex(X, 'F'),
	(father(Y, X) ; mother(Y, X)).
```
Сначала решил сделать только такое количество родственников.
Далее я реализовал поиск в глубину, он сразу сдох(дерево из 150 человек), далее попробовал поиск в ширину он работал, но ОЧЕНЬ долго, я даже не смог один раз дожидаться результата.

Поэтому я понял, что нужно увеличить шаг, и я добавил следуюшее:
```Prolog 
% X внук Y
grandson(X, Y):-
	sex(X, 'M'),
	(	father(Z, X),
		father(Y, Z)
	;	mother(C, X),
		father(Y, C)
	).
% X внучка Y
granddaughter(X, Y):-
	sex(X, 'F'),
	(	father(Z, X),
		father(Y, Z)
	;	mother(C, X),
		father(Y, C)
	).
% X дедушка Y
grandfather(X, Y):-
	father(X, Z),
	(	father(Z, Y)
	;	mother(Z, Y)
	).
% X бабушка Y
grandmother(X, Y):-
	mother(X, Z),
	(	father(Z, Y)
	;	mother(Z, Y)
	).
% X тесть или свекор Y
fatherinlaw(X, Y):-
	(	father(Y, C),
		mother(W, C)
	;	mother(Y, C),
		father(W, C)
	),
	father(X, W).
% X теща или свекровь Y
motherinlaw(X, Y):-
	(	father(Y, C),
		mother(W, C)
	;	mother(Y, C),
		father(W, C)
	),
	mother(X, W).
```

В итоге я решил использовать итеративный поиск с такими путями отношений:
```Prolog 
% движения для алгоритма поиска
move(X, Y, grandson):- grandson(X, Y).
move(X, Y, granddaughter):- granddaughter(X, Y).
move(X, Y, grandfather):- grandfather(X, Y).
move(X, Y, grandmother):- grandmother(X, Y).
move(X, Y, fatherinlaw):- fatherinlaw(X, Y).
move(X, Y, motherinlaw):- motherinlaw(X, Y).
move(X, Y, father):-father(X, Y).
move(X, Y, mother):-mother(X, Y).
move(X, Y, son):-son(X, Y).
move(X, Y, daughter):-daughter(X, Y).
move(X, Y, brother):-brother(X, Y).
move(X, Y, sister):-sister(X, Y).
move(X, Y, husband):- husband(X, Y).
move(X, Y, wife):- wife(X, Y).

% итерационный поиск
%%%%%%%%%%%%%%%%%%%%
int(1).
int(N):-
	int(M),
	N is M+1.

iter([Now|T1], Now, [Now|T1], [], 1). 
iter([Now|T1], Final, Path, [Rel|T2], N):-
	N>0,
	move(Now, New, Rel),
	not(member(New, [Now|T1])),
	N1 is N-1,
	iter([New, Now|T1], Final, Path, T2, N1).

iter_search(Start, Fin, Path, Rel):-
	int(N),
	(	N > 50, !
	;	iter([Start], Fin, Path, Rel, N)
	).
%%%%%%%%%%%%%%%%%%%%

% Определение степени родства
contact(X, Y, Ans):-
	iter_search(X, Y, _, Ans),!.
```

Результат работы предиката:
```Prolog
?- contact('Egor Kondratev','Larisa Larkin',Path).
Path = [grandson, brother].

?- contact('Kolya Nikaladean','Dmitry Kondratev',Path).
Path = [grandson, husband, granddaughter, grandfather, grandfather, grandson].
```


## Естественно-языковый интерфейс

На основании входных данных проверяем правильность утверждения, правильно ли находит результат. В качестве входных данных мы берем список слов естественного языка. Также при использовании предиката nb_getval() имя запоминается для возможности последующего обращения к ней, а также для построения с ней предложений. Это имя далее используется с предикатом nb_setval().

Используя предикаты из предыдущих абзацев, KP реализовал простой интерфейс на естественном языке, в котором запросы могут быть указаны в форме:
```Prolog
?- q(['who', is, 'Michail Pisarev', s, sister, ?]).
Alexandra Pisarev is Michail Pisarev`s sister,
Elizabeth Pisarev is Michail Pisarev`s sister,
Nadya Pisareva is Michail Pisarev`s sister,
Nina Pisarev is Michail Pisarev`s sister,
Polina Pisarev is Michail Pisarev`s sister.
true.

?- q([what, is, relationship, between, he, and, 'Kolya Nikaladean',?]).
Relationship between Michail Pisarev and Kolya Nikaladean is [son,grandfather,grandmother].
true.

?- q(['how many',grandsons,does,'Akim Pisarev',has,?]).
Akim Pisarev has 8 grandsons.
true.

?- q([what, is, relationship, between, he, and, 'Alexandra Larkina',?]).
Relationship between Akim Pisarev and Alexandra Larkina is [grandfather,grandson,fatherinlaw].
true.

?- q(['who', is, 'Kate Dofbysh', s, brother, ?]).
Egor Kondratev is Kate Dofbysh`s brother.
true.

?- q([what, is, relationship, between, he, and, she,?]).
Relationship between Akim Pisarev and Kate Dofbysh is [grandfather,grandfather].
true.

```

Представлю "кишки" данной обработки.

```Prolog
% предикат сохранения и загрузки связи местоимений
setval(X):- sex(X,'F'),nb_setval(last_female,X).
setval(X):- sex(X,'M'),nb_setval(last_male,X).
getval(X,Name):- female_pronoun(X),!,nb_getval(last_female,Name).
getval(X,Name):- male_pronoun(X),!,nb_getval(last_male,Name).

% Пример запроса: [how many, *relation*, does, *name*/*pronoun*, have ,?]
q(Q):-
	Q = [Word, R, W2, Who, W3, W4],
	question1(Word), various(Rel, R), do(W2), name(Who), setval(Who), 
	have(W3), qstn(W4), setof(X, move(X, Name, Rel),  T), length(T, Res), !,
	write(Name), write(" has "), write(Res), write(" "),  writes(Rel, Res), write("."), !.
q(Q):-
	Q = [Word, R, W2, Who, W3, W4],
	question1(Word), various(Rel, R), do(W2), pronoun(Who), getval(Who,Name), 
	have(W3), qstn(W4), setof(X, move(X, Name, Rel), T), length(T, Res), !,
	write(Name), write(" has "), write(Res), write(" "), writes(Rel, Res), write("."), !.

% Пример запроса: [who, is, *name*/*pronoun*,s, *relation*, ?]
q(Q):-
	Q = [Word, W1, Who, W2, R, W3],
	question2(Word), is(W1),name(Who),setval(Who),suffix(W2),
	relation(R),qstn(W3),setof(Res,move(Res, Who, R),T),print(T,Who,R),!.
q(Q):-
	Q = [Word, W1, Who, W2, R, W3],
	question2(Word), is(W1),pronoun(Who),getval(Who,Name),suffix(W2),
	relation(R),qstn(W3),setof(Res,move(Res, Name, R),T),print(T,Name,R),!.

% Пример запроса: [what, is, relationship, between, *name*/*pronoun*, and, *name*/*pronoun*, ?]
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5],question3(Word),is(W1),rel(W2),bet(W3),
	name(Who1),setval(Who1),aand(W4),name(Who2),setval(Who2),qstn(W5),
	contact(Who1,Who2,Res),
	write('Relationship between '), write(Who1), write(' and '), write(Who2), write(' is '), write(Res),write('.'), nl,!.
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5], question3(Word), is(W1), rel(W2),bet(W3),
	pronoun(Who1), getval(Who1, Name), aand(W4), name(Who2), setval(Who2), qstn(W5),
	contact(Name,Who2,Res),
	write('Relationship between '), write(Name), write(' and '), write(Who2), write(' is '), write(Res),write('.'), nl,!.
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5],question3(Word),is(W1),rel(W2),bet(W3),
	name(Who1),setval(Who1),aand(W4),pronoun(Who2),getval(Who2,Name),qstn(W5),
	contact(Who1,Name,Res),
	write('Relationship between '), write(Who1), write(' and '), write(Name), write(' is '), write(Res),write('.'), nl,!.
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5],question3(Word),is(W1),rel(W2),bet(W3),
	pronoun(Who1),getval(Who1,Name1),aand(W4),pronoun(Who2),getval(Who2,Name2),qstn(W5),
	contact(Name1,Name2,Res),
	write('Relationship between '), write(Name1), write(' and '), write(Name2), write(' is '), write(Res),write('.'), nl,!.

```



## Выводы

Изначально, когда я еще не был знаком с таким логическим языком программирования, как «Пролог», мне было сложно понять, как он работает, потому что все языки, с которыми я сталкивался, были скомпилированы, например, C, C++, Java, Python. После долгих мучений мне удалось осознать разницу между императивной и логической парадигмой, понял их основные принципы и особенности, плюсы и минусы, научился пользоваться различными средствами пролога – обрабатывать списки, графы, вычислять предикаты и на их основе составлять целые базы. Язык мне даже понравился. Переменных как таковых нет, мы описываем условия, что мы хотим и как мы хотим это получить, что позволяет нам применять этот язык к логическим задачам. В этой работе(пункт 4 и 5) я увидел практический смысл этого языка, и мне очень нравится эта перспектива. 
