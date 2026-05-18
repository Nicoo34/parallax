ax.localization:Register("fr", {
    ["tab.recognition"] = "Journal",

    -- Recognition Module
    --- Tiers
    ["recognition.tier.stranger"] = "Inconnu",
    ["recognition.tier.seen"] = "Vu",
    ["recognition.tier.acquainted"] = "Connu",
    ["recognition.tier.known"] = "Connu",
    ["recognition.tier.trusted"] = "Fiable",

    --- Relative time
    ["recognition.time.just_now"] = "à l'instant",
    ["recognition.time.minutes_ago"] = "il y a %d minutes",
    ["recognition.time.hours_ago"] = "il y a %d heures",
    ["recognition.time.days_ago"] = "il y a %d jours",
    ["recognition.time.weeks_ago"] = "il y a %d semaines",

    --- Client notifications
    ["recognition.notify.no_target"] = "Aucun joueur valide dans votre ligne de vue.",
    ["recognition.notify.no_character"] = "Le joueur cible n'a pas de personnage actif.",
    ["recognition.notify.alias_empty"] = "L'alias ne peut pas être vide.",
    ["recognition.notify.alias_too_long"] = "L'alias doit faire 48 caractères ou moins.",

    --- Server notifications
    ["recognition.notify.alias_invalid_length"] = "L'alias doit faire entre 1 et 48 caractères.",
    ["recognition.notify.no_permission"] = "Vous n'avez pas la permission de définir la familiarité.",
    ["recognition.notify.char_not_loaded"] = "L'ID du personnage %d n'est pas chargé.",
    ["recognition.notify.set_success"] = "Familiarité définie pour le personnage %d envers %d à %d.",
    ["recognition.notify.too_far"] = "Vous êtes trop éloigné pour vous présenter.",
    ["recognition.notify.invalid_target"] = "Cible invalide.",
    ["recognition.notify.self_introduce"] = "Vous ne pouvez vous présenter à vous-même.",

    --- Command feedback
    ["recognition.command.invalid_executor"] = "Exécuteur invalide.",
    ["recognition.command.no_character"] = "Vous n'avez pas de personnage actif.",
    ["recognition.command.invalid_target"] = "Cible invalide.",
    ["recognition.command.target_no_character"] = "Le joueur cible n'a pas de personnage actif.",

    --- Journal UI
    ["recognition.journal.title"] = "Journal",
    ["recognition.journal.header.name"] = "Personnages connus",
    ["recognition.journal.header.tier"] = "Niveau",
    ["recognition.journal.header.last_seen"] = "Dernier vu",
    ["recognition.journal.empty"] = "Vous n'avez pas encore rencontré personne.",
    ["recognition.journal.forget"] = "Oublier",

    --- Introduced notification
    ["recognition.notify.introduced"] = "Quelqu'un s'est présenté comme \"%s\".",

    --- Introduce dialog
    ["recognition.introduce.title"] = "Présentation",
    ["recognition.introduce.prompt"] = "Présentez-vous à %s comme...",

    --- Admin view output
    ["recognition.admin.view.header"] = "[Reconnaissance] Cible : %s (%s)",
    ["recognition.admin.view.true_name"] = "  Vrai nom : %s",
    ["recognition.admin.view.toward_you"] = "  Vers vous : score=%d  tier=%s  alias=%s",
    ["recognition.admin.alias_none"] = "(aucun)",

    ["config.recognition_tick_interval"] = "Intervalle de Ticks",
    ["config.recognition_tick_interval.help"] = "Secondes entre les ticks de familiarité passifs.",

    ["config.recognition_passive_gain"] = "Gain Passif",
    ["config.recognition_passive_gain.help"] = "Score obtenu par tick de proximité.",

    ["config.recognition_ic_bonus"] = "Bonus IC",
    ["config.recognition_ic_bonus.help"] = "Bonus par message IC entendu.",

    ["config.recognition_whisper_bonus"] = "Whisper Bonus",
    ["config.recognition_whisper_bonus.help"] = "Bonus par murmure entendu.",

    ["config.recognition_yell_bonus"] = "Yell Bonus",
    ["config.recognition_yell_bonus.help"] = "Bonus par cri entendu.",

    ["config.recognition_decay_days"] = "Jours avant décroissement",
    ["config.recognition_decay_days.help"] = "Jours d'inactivité avant que le score ne commence à décroître. Mettre à 0 pour désactiver.",

    ["config.recognition_decay_amount"] = "Montant du Décroissement",
    ["config.recognition_decay_amount.help"] = "Score perdu par cycle de décroissement quotidien.",

    ["config.recognition_unknown_colour"] = "Couleur Inconnue",
    ["config.recognition_unknown_colour.help"] = "Couleur utilisée sur les plaques de nom et dans le chat pour les personnages non reconnus."



})


