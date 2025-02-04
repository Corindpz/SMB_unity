# interrogation de la base biblio

-- Rqt 1
-- Sélectionnez tous les adhérents qui ont pour prénom 'Abel' (*)
SELECT * FROM adherent WHERE prenom = 'Abel';

-- Rqt 2
-- Combien de fois a été emprunté le livre dont l'id est 15 (id_livre, nbEmprunt) ? 
SELECT id_livre, COUNT(*) AS nbEmprunt FROM emprunt WHERE id_livre = 15 GROUP BY id_livre;


-- Rqt 3. 
-- Combien de fois a été rendu le livre dont l'id est 15 (id_livre, nbRetour) ?
SELECT id_livre, COUNT(*) AS nbRetour FROM emprunt WHERE id_livre = 15 AND date_retour IS NOT NULL GROUP BY id_livre;


-- Rqt 4. 
-- Quel est le nombre de d'adhérents (nbAdherent)?
SELECT COUNT(*) AS nbAdherent FROM adherent;


-- Rqt 5. 
-- Combien de livres contient la bibliothèque (nbLIvre)?
SELECT COUNT(*) AS nbLivre FROM livre;


-- Rqt 6. 
-- Quels sont les livres qui n'ont pas d'auteur (id_livre, titre) ?
SELECT id_livre, titre FROM livre WHERE id_auteur IS NULL;

-- Rqt 7. 
-- Quels sont les auteurs qui ont écrit plus d'un livre (id_auteur, nom, prenom, nbLivreEcrit)?
SELECT id_auteur, nom, prenom, COUNT(*) nbLivreEcrit FROM livres GROUP BY id_auteur, nom, prenom HAVING COUNT(*) > 1;

-- Rqt 8. 
-- Quels sont les livres qui n'ont jamais été empruntés (id_livre, titre) ?
SELECT id_livre, titre FROM livre WHERE id_livre NOT IN (SELECT id_livre FROM emprunt);

-- Rqt 9.  
-- Quels sont les livres en cours d'emprunt (id_livre, titre, id_adherent, date_emprunt, date_retour) ?
SELECT id_livre, titre, id_adherent, date_emprunt, date_retour FROM emprunt WHERE date_retour IS NULL;


-- Rqt 10. 
-- Quels sont les livres en cours d'emprunt et en retard (id_livre, titre, id_adherent, date_emprunt, date_retour)?

SELECT e.id_livre, l.titre, e.id_adherent, e.date_emprunt, e.date_retour FROM emprunt e JOIN livre l ON e.id_livre = l.id_livre WHERE e.date_retour < CURDATE() AND e.date_retour IS NOT NULL;


-- Rqt 11. 
-- Afficher pour chaque livre le nombre d'exemplaires disponibles (id_livre, titre, nbExemplaireDispo)

SELECT l.id_livre, l.titre, (COUNT(e.id_livre) - COUNT(e.date_retour IS NULL OR NULL)) AS nbExemplaireDispo
FROM livre l
LEFT JOIN emprunt e ON l.id_livre = e.id_livre
GROUP BY l.id_livre, l.titre;

-- Rqt 12. 
-- Afficher les id des adhérents et leur nombre d'emprunts ayant fait plus de 5 emprunts après le 01/07/2022 (id_adherent, nbEmprunt)

SELECT e.id_adherent, COUNT(*) AS nbEmprunt
FROM emprunt e
WHERE e.date_emprunt > '2022-07-01'
GROUP BY e.id_adherent
HAVING nbEmprunt > 5;


-- Rqt 13. 
-- Quel est l'auteur le plus emprunté (id_auteur, nom, prénom)


SELECT a.id_auteur, a.nom, a.prenom, COUNT(e.id_livre) AS nombre_empruntsFROM auteur a JOIN ecrit ec ON a.id_auteur = ec.id_auteur
JOIN emprunt e ON ec.id_livre = e.id_livre
GROUP BY a.id_auteur, a.nom, a.prenom
ORDER BY nombre_emprunts DESC
LIMIT 1;

-- Rqt 14. 
-- Afficher l'ensemble des adhérents avec leur numéro de téléphone s'ils en ont (id_adherent, nom, prenom, email, rue, ville, code_postal, date_naissance, id_tel, numero, type_num)

SELECT a.id_adherent, a.nom, a.prenom, a.email, a.rue, a.ville, a.code_postal, a.date_naissance, t.id_tel, t.numero, t.type_num
FROM adherent a
LEFT JOIN telephone t ON a.id_adherent = t.id_adherent;

-- Rqt 15 
-- Quel est l'age moyen des adherents (AgeMoyen).

SELECT AVG(TIMESTAMPDIFF(YEAR, date_naissance, CURDATE())) AS AgeMoyen
FROM adherent;

-- Rqt 16
-- Quel est le nombre de cotisation effectué et le montant de cotisation encaissé en mars 2022 ? (nbCotisation, montantTotal)

SELECT COUNT(*) AS nbCotisation, SUM(c.montant) AS montantTotal
FROM cotisation c
JOIN adherent a ON c.type_cotisation = a.type_cotisation
WHERE a.date_cotisation BETWEEN '2022-03-01' AND '2022-03-31';

-- Rqt 17
-- Combien de livres au total ont emprunté et rendu les adhérents "adultes" (type_cotisation, nbLivres)

SELECT a.type_cotisation, COUNT(e.id_livre) AS nbLivres
FROM adherent a
JOIN emprunt e ON a.id_adherent = e.id_adherent
WHERE a.type_cotisation = 'adulte' AND e.date_retour IS NOT NULL
GROUP BY a.type_cotisation;


-- Rqt 18
-- Quel est le type de cotisation qui a le plus emprunté le livre "C'est elle qui a commencé" (type_cotisation, nb_emprunt)

SELECT a.type_cotisation, COUNT(e.id_livre) AS nb_emprunt
FROM emprunt e
JOIN livre l ON e.id_livre = l.id_livre
JOIN adherent a ON e.id_adherent = a.id_adherent
WHERE l.titre = "C'est elle qui a commencé"
GROUP BY a.type_cotisation
ORDER BY nb_emprunt DESC
LIMIT 1;


-- Rqt 19
-- Quel est l'auteur qui a écrit le plus de livre (id_auteur, nom, prenom, nbLivre) ?

SELECT a.id_auteur, a.nom, a.prenom, COUNT(e.id_livre) AS nbLivre
FROM auteur a
JOIN ecrit e ON a.id_auteur = e.id_auteur
GROUP BY a.id_auteur, a.nom, a.prenom
ORDER BY nbLivre DESC
LIMIT 1;

-- Rqt 20 
-- Quel est le livre le plus emprunté (id_livre, titre, nb_emprunt)

SELECT l.id_livre, l.titre, COUNT(e.id_livre) AS nb_emprunt
FROM livre l
JOIN emprunt e ON l.id_livre = e.id_livre
GROUP BY l.id_livre, l.titre
ORDER BY nb_emprunt DESC
LIMIT 1;

-- Rqt 21 
-- Pour chaque ville, sa population d'adhérents, trié du nombre d'adhérents le plus élevé au moins élevé (ville, code_postal, nb_adherent)

SELECT ville, code_postal, COUNT(id_adherent) AS nb_adherent
FROM adherent
GROUP BY ville, code_postal
ORDER BY nb_adherent DESC;

-- Rqt 22 
-- Pour chaque ville, listez le livre ayant le plus de succès par ville (ville, code_postal, id_livre, nb_emprunt)
SELECT 
    a.ville, 
    a.code_postal, 
    e.id_livre, 
    COUNT(e.id_livre) AS nb_emprunt
FROM 
    adherent a
JOIN 
    emprunt e ON a.id_adherent = e.id_adherent
GROUP BY 
    a.ville, a.code_postal, e.id_livre
ORDER BY 
    a.ville, nb_emprunt DESC;