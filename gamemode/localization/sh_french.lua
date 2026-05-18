ax.localization:Register("fr", {
    -- General
    ["yes"] = "Oui",
    ["no"] = "Non",
    ["ok"] = "OK",
    ["cancel"] = "Annuler",
    ["apply"] = "Appliquer",
    ["close"] = "Fermer",
    ["back"] = "Retour",
    ["next"] = "Suivant",
    ["unknown"] = "Inconnu",

    ["skin"] = "Skin",
    ["model"] = "Modèle",
    ["name"] = "Nom",
    ["description"] = "Description",

    ["not_enough_money"] = "Vous n'avez pas assez d'argent pour acheter ceci.",
    ["not_enough_money_missing"] = "Vous n'avez pas assez d'argent pour acheter ceci. Il vous manque %s.",

    -- Main Menu Translations
    ["mainmenu.category.00_faction"] = "Factions",
    ["mainmenu.category.01_appearance"] = "Apparence",

    ["mainmenu.category.02_identity"] = "Identité",
    ["mainmenu.category.02_identity.hint_name_1"] = "Utilisez les majuscules et indiquez à la fois un prénom et un nom de famille.",
    ["mainmenu.category.02_identity.hint_name_2"] = "Votre nom doit correspondre au thème du serveur et au cadre du roleplay.",

    ["mainmenu.category.02_identity.hint_description_1"] = "La description du personnage est un bref résumé qui aide les autres à visualiser votre personnage. Elle peut inclure des détails sur l'apparence physique, le style vestimentaire ou tout trait de caractère notable.",
    ["mainmenu.category.02_identity.hint_description_2"] = "Écrivez une courte description de votre apparence physique, de votre style vestimentaire ou de tout trait qui aide les autres à visualiser votre personnage.",

    ["mainmenu.category.03_other"] = "Autre",
    ["mainmenu.create"] = "Créer un personnage",
    ["mainmenu.disconnect"] = "Déconnexion",
    ["mainmenu.load"] = "Charger un personnage",
    ["mainmenu.options"] = "Options",
    ["mainmenu.play"] = "Jouer",

    -- Pause Menu Translations
    ["pause.title"] = "Pause",
    ["pause.resume"] = "Reprendre",
    ["pause.characters"] = "Personnages",
    ["pause.options"] = "Options",
    ["pause.disconnect"] = "Déconnexion",
    ["pause.legacy"] = "Menu classique",

    -- Tab Menu Translations
    ["tab.config"] = "Configuration",
    ["tab.help"] = "Aide",
    ["tab.help.overview"] = "Vue d'ensemble",
    ["tab.help.commands"] = "Commandes",
    ["tab.help.factions"] = "Factions",
    ["tab.help.modules"] = "Modules",
    ["tab.inventory"] = "Inventaire",
    ["tab.scoreboard"] = "Tableau des scores",
    ["tab.settings"] = "Paramètres",
    ["tab.characters"] = "Personnages",

    -- Category Translations
    ["category.chat"] = "Chat",
    ["category.gameplay"] = "Gameplay",
    ["category.general"] = "Général",
    ["category.audio"] = "Audio",
    ["category.interface"] = "Interface",
    ["category.modules"] = "Modules",
    ["category.recognition"] = "Reconnaissance",
    ["category.schema"] = "Schéma",

    -- Subcategory Translations
    ["subcategory.basic"] = "Basique",
    ["subcategory.buttons"] = "Boutons",
    ["subcategory.characters"] = "Personnages",
    ["subcategory.colors"] = "Couleurs",
    ["subcategory.display"] = "Affichage",
    ["subcategory.appearance"] = "Apparence",
    ["subcategory.animations"] = "Animations",
    ["subcategory.performance"] = "Performance",
    ["subcategory.behavior"] = "Comportement",
    ["subcategory.distances"] = "Distances",
    ["subcategory.effects"] = "Effets",
    ["subcategory.formatting"] = "Mise en forme",
    ["subcategory.fonts"] = "Polices",
    ["subcategory.hud"] = "HUD",
    ["subcategory.interaction"] = "Interaction",
    ["subcategory.inventory"] = "Inventaire",
    ["subcategory.layout"] = "Mise en page",
    ["subcategory.movement"] = "Mouvement",
    ["subcategory.notifications"] = "Notifications",
    ["subcategory.position"] = "Position",
    ["subcategory.size"] = "Taille",
    ["subcategory.typography"] = "Typographie",
    ["subcategory.general"] = "Général",
    ["subcategory.ooc"] = "OOC",
    ["subcategory.audio"] = "Audio",
    ["subcategory.tools"] = "Outils",
    ["subcategory.respawn"] = "Réapparition",

    -- Store Translations
    ["store.enabled"] = "Activé",
    ["store.disabled"] = "Désactivé",
    ["store.default"] = "Par défaut",
    ["store.type.bool"] = "Interrupteur",
    ["store.type.number"] = "Nombre",
    ["store.type.string"] = "Texte",
    ["store.type.color"] = "Couleur",
    ["store.type.array"] = "Choix",
    ["store.type.keybind"] = "Raccourci clavier",

    -- Config Translations

    --- Chat
    ---- Distances
    ["config.chat.ic.distance"] = "Distance du chat IC",
    ["config.chat.me.distance"] = "Distance du chat ME",
    ["config.chat.ooc.distance"] = "Distance du chat OOC",
    ["config.chat.yell.distance"] = "Distance du chat YELL",
    ["config.chat.ooc.enabled"] = "Activer le chat OOC",
    ["config.chat.ooc.delay"] = "Délai des messages OOC (secondes)",
    ["config.chat.ooc.rate_limit"] = "Messages OOC par 10 minutes",

    --- Gameplay
    ---- Interaction
    ["config.hands.force.max"] = "Force maximale des mains",
    ["config.hands.force.max.throw"] = "Force maximale de lancer",
    ["config.hands.max.carry"] = "Poids maximal transportable",
    ["config.hands.range.max"] = "Distance maximale de portée",

    ---- Inventory
    ["config.inventory.weight.max"] = "Poids maximal de l'inventaire",
    ["config.inventory.sync.delta"] = "Synchronisation partielle de l'inventaire",
    ["config.inventory.sync.debounce"] = "Délai de synchronisation de l'inventaire",
    ["config.inventory.sync.full_refresh_interval"] = "Intervalle de rafraîchissement complet de l'inventaire",
    ["config.inventory.action.rate_limit"] = "Limite de fréquence des actions d'inventaire",
    ["config.inventory.transfer.rate_limit"] = "Limite de fréquence des transferts d'inventaire",
    ["config.inventory.pagination.default_page_size"] = "Taille de page par défaut de l'inventaire",
    ["config.inventory.pagination.max_page_size"] = "Taille maximale de page d'inventaire",
    ["config.inventory.restore.batch_size"] = "Taille du lot de restauration de l'inventaire",
    ["config.inventory.sync.delta.help"] = "Active la synchronisation delta pour n'envoyer que les objets modifiés.",
    ["config.inventory.sync.debounce.help"] = "Délai (secondes) avant d'envoyer les mises à jour de synchronisation de l'inventaire.",
    ["config.inventory.sync.full_refresh_interval.help"] = "Secondes minimales entre les rafraîchissements complets quand la synchro delta est activée.",
    ["config.inventory.action.rate_limit.help"] = "Délai minimal en secondes entre les actions d'objet par joueur.",
    ["config.inventory.transfer.rate_limit.help"] = "Délai minimal en secondes entre les demandes de transfert d'inventaire par joueur.",
    ["config.inventory.pagination.default_page_size.help"] = "Nombre par défaut de piles d'objets par page d'inventaire.",
    ["config.inventory.pagination.max_page_size.help"] = "Nombre maximal de piles d'objets autorisées par page.",
    ["config.inventory.restore.batch_size.help"] = "Nombre d'objets d'inventaire au sol restaurés par lot de synchronisation.",

    ---- Movement
    ["config.jump.power"] = "Puissance de saut",
    ["config.movement.bunnyhop.reduction"] = "Réduction de vitesse du bunnyhop",
    ["config.speed.run"] = "Vitesse de course",
    ["config.speed.walk"] = "Vitesse de marche",
    ["config.speed.walk.crouched"] = "Vitesse accroupie",
    ["config.speed.walk.slow"] = "Vitesse de marche lente",

    ---- Respawn
    ["config.respawn.delay"] = "Délai de réapparition",
    ["config.respawn.delay.help"] = "Durée en secondes avant qu'un joueur puisse réapparaître après sa mort.",

    ---- Misc
    ["respawning"] = "Réapparition...",
    ["command.notvalid"] = "Cela ne ressemble pas à une commande valide.",
    ["command.notfound"] = "Aucune commande avec ce nom. Vérifiez l'orthographe.",
    ["command.executionfailed"] = "Cette commande a échoué. Réessayez.",
    ["command.unknownerror"] = "Quelque chose s'est mal passé. Veuillez réessayer.",

    ["buildmenu.name.spawn"] = "Spawn",
    ["buildmenu.name.context"] = "Context",
    ["buildmenu.requires_tools"] = "Vous avez besoin des outils de construction pour accéder au menu %s.",

    --- General
    ---- Basic
    ["config.language"] = "Langue",

    ---- Characters
    ["config.autosave.interval"] = "Intervalle d'enregistrement automatique des personnages",
    ["config.characters.max"] = "Nombre maximal de personnages",

    -- Audio
    ["config.proximity"] = "Activer le chat vocal de proximité",
    ["config.proximity.help"] = "Indique si le système de proximité est activé.",
    ["config.proximityMaxDistance"] = "Distance maximale du chat vocal",
    ["config.proximityMaxDistance.help"] = "Portée maximale de la voix en jeu.",
    ["config.proximityMaxTraces"] = "Nombre maximal de traces de proximité",
    ["config.proximityMaxTraces.help"] = "Nombre maximal de traces à effectuer lors du calcul du volume vocal.",
    ["config.proximityMaxVolume"] = "Volume maximal du chat vocal",
    ["config.proximityMaxVolume.help"] = "Limite le volume sonore maximum de la voix des joueurs.",
    ["config.proximityMuteVolume"] = "Volume muet du chat vocal",
    ["config.proximityMuteVolume.help"] = "Niveau du son quand un joueur est mis en sourdine.",
    ["config.proximityUnMutedDistance"] = "Distance de réactivation du son",
    ["config.proximityUnMutedDistance.help"] = "Distance à laquelle un joueur n'est plus mis en sourdine.",

    -- Options Translations
    --- Chat
    ---- Basic
    ["option.chat.sounds"] = "Activer les sons du chat",
    ["option.chat.timestamps"] = "Afficher les horodatages dans le chat",
    ["option.chat.timestamps.24hour"] = "Utiliser le format 24 h pour les horodatages",
    ["option.chat.randomized.verbs"] = "Utiliser des verbes de chat aléatoires",
    ["option.chat.randomized.verbs.help"] = "Quand activé, les messages utilisent des verbes variés (s'exclame, marmonne, crie). Sinon, ils utilisent les verbes par défaut (dit, chuchote, hurle).",

    ---- Position
    ["option.chat.x"] = "Position X de la chatbox",
    ["option.chat.y"] = "Position Y de la chatbox",

    ---- Size
    ["option.chat.width"] = "Largeur de la chatbox",
    ["option.chat.height"] = "Hauteur de la chatbox",

    --- Interface
    ---- Chat
    ["config.chat.ic.color"] = "Couleur du chat IC",
    ["config.chat.me.color"] = "Couleur du chat ME",
    ["config.chat.ooc.color"] = "Couleur du chat OOC",
    ["config.chat.yell.color"] = "Couleur du chat YELL",
    ["config.chat.whisper.color"] = "Couleur du chat WHISPER",

    ---- Buttons
    ["option.button.delay.click"] = "Délai de clic des boutons",

    ---- Display
    ["option.interface.scale"] = "Échelle de l'interface",
    ["option.interface.theme"] = "Thème de l'interface",
    ["option.interface.theme.help"] = "Choisissez le thème de couleur de l'interface.",
    ["option.interface.glass.roundness"] = "Arrondi du verre",
    ["option.interface.glass.roundness.help"] = "Ajustez le rayon des coins des éléments d'interface en verre.",
    ["option.interface.glass.blur"] = "Intensité du flou du verre",
    ["option.interface.glass.blur.help"] = "Contrôle l'intensité du flou derrière les éléments d'interface en verre.",
    ["option.interface.glass.opacity"] = "Opacité du verre",
    ["option.interface.glass.opacity.help"] = "Ajustez l'opacité des panneaux d'interface en verre.",
    ["option.interface.glass.borderOpacity"] = "Opacité des bordures en verre",
    ["option.interface.glass.borderOpacity.help"] = "Contrôle la visibilité des bordures de l'interface en verre.",
    ["option.interface.glass.gradientOpacity"] = "Opacité du dégradé en verre",
    ["option.interface.glass.gradientOpacity.help"] = "Ajustez la force des superpositions de dégradé sur les panneaux en verre.",
    ["option.performance.animations"] = "Activer les animations de l'interface",
    ["option.performance.animations.help"] = "Active ou désactive les animations d'interpolation et de transition de l'interface.",
    ["option.performance.blur"] = "Activer le flou de l'interface",
    ["option.performance.blur.help"] = "Désactive les passes de flou coûteuses en arrière-plan sur les éléments d'interface en verre.",
    ["option.performance.vignette.trace"] = "Activer la trace de proximité de vignette",
    ["option.performance.vignette.trace.help"] = "Contrôle la trace proche des murs utilisée pour ajuster l'intensité de la vignette.",
    ["option.performance.voice.indicators"] = "Activer les indicateurs de voix",
    ["option.performance.voice.indicators.help"] = "Active ou désactive les indicateurs d'activité vocale dans le HUD et le monde.",

    -- Theme Names
    ["theme.dark"] = "Sombre",
    ["theme.light"] = "Clair",
    ["theme.blue"] = "Bleu",
    ["theme.purple"] = "Violet",
    ["theme.green"] = "Vert",
    ["theme.red"] = "Rouge",
    ["theme.orange"] = "Orange",

    ---- Fonts
    ["option.fontScaleGeneral"] = "Échelle générale de la police",
    ["option.fontScaleGeneral.help"] = "Multiplicateur général de l'échelle des polices.",
    ["option.fontScaleSmall"] = "Échelle de la petite police",
    ["option.fontScaleSmall.help"] = "Modificateur d'échelle pour les petites polices. Des valeurs plus basses rendent les petites polices plus grandes.",
    ["option.fontScaleBig"] = "Échelle de la grande police",
    ["option.fontScaleBig.help"] = "Modificateur d'échelle pour les grandes polices. Des valeurs plus élevées rendent les grandes polices plus petites.",

    ---- HUD
    ["option.hud.bar.armor.show"] = "Afficher la barre d'armure",
    ["option.hud.bar.health.show"] = "Afficher la barre de vie",
    ["option.hud.elements.enabled"] = "Activer les éléments du HUD",
    ["option.hud.targetid.enabled"] = "Activer les labels TargetID",
    ["option.hud.targetid.distance"] = "Distance TargetID",
    ["option.hud.targetid.fade_speed_in"] = "Vitesse de fondu d'entrée TargetID",
    ["option.hud.targetid.fade_speed_out"] = "Vitesse de fondu de sortie TargetID",
    ["option.hud.targetid.position_speed"] = "Vitesse de suivi TargetID",
    ["option.hud.targetid.max_width"] = "Largeur de description TargetID",
    ["option.hud.targetid.line_spacing"] = "Espacement des lignes TargetID",
    ["option.hud.targetid.visible_delay"] = "Délai de visibilité TargetID",
    ["option.hud.targetid.player_offset"] = "Décalage joueur TargetID",
    ["option.hud.targetid.flash_speed"] = "Vitesse de clignotement TargetID",
    ["option.hud.targetid.show_descriptions"] = "Afficher les descriptions TargetID",
    ["option.hud.targetid.show_extras"] = "Afficher les lignes supplémentaires TargetID",
    ["option.hud.elements.enabled.help"] = "Active ou désactive tous les éléments HUD du framework.",
    ["option.hud.targetid.enabled.help"] = "Active ou désactive les labels TargetID lorsque vous regardez des entités.",
    ["option.hud.targetid.distance.help"] = "Distance à laquelle les labels TargetID peuvent détecter les entités.",
    ["option.hud.targetid.fade_speed_in.help"] = "Vitesse à laquelle les labels TargetID apparaissent.",
    ["option.hud.targetid.fade_speed_out.help"] = "Vitesse à laquelle les labels TargetID disparaissent.",
    ["option.hud.targetid.position_speed.help"] = "Vitesse à laquelle les labels TargetID suivent les entités en mouvement.",
    ["option.hud.targetid.max_width.help"] = "Largeur maximale de description TargetID avant retour à la ligne.",
    ["option.hud.targetid.line_spacing.help"] = "Espacement vertical entre les lignes de description TargetID.",
    ["option.hud.targetid.visible_delay.help"] = "Durée pendant laquelle les labels TargetID restent visibles après perte de visée.",
    ["option.hud.targetid.player_offset.help"] = "Décalage vertical des labels TargetID pour les joueurs et leurs ragdolls.",
    ["option.hud.targetid.flash_speed.help"] = "Vitesse de pulsation des labels TargetID en clignotement.",
    ["option.hud.targetid.show_descriptions.help"] = "Afficher les descriptions par défaut des objets et personnages sous les labels TargetID.",
    ["option.hud.targetid.show_extras.help"] = "Afficher les lignes de description supplémentaires fournies par les entités.",
    ["option.notification.enabled"] = "Activer les notifications",
    ["option.notification.length.default"] = "Durée par défaut des notifications",
    ["option.notification.scale"] = "Échelle des notifications",
    ["option.notification.sounds"] = "Activer les sons de notification",
    ["option.notification.position"] = "Position des notifications",

    ---- Inventory
    ["option.inventory.categories.italic"] = "Mettre les noms de catégories en italique",
    ["option.inventory.columns"] = "Nombre de colonnes d'inventaire",
    ["option.store.columns"] = "Nombre de colonnes du store",
    ["option.inventory.sort.categories"] = "Mode de tri des catégories d'inventaire",
    ["option.inventory.sort.items"] = "Mode de tri des objets d'inventaire",
    ["option.inventory.search.live"] = "Recherche d'inventaire en temps réel",
    ["option.inventory.categories.collapsible"] = "Catégories d'inventaire repliables",
    ["option.inventory.pagination.page_size"] = "Taille de page d'inventaire",
    ["option.inventory.actions.confirm_bulk_drop"] = "Confirmer les dépôts multiples",
    ["option.inventory.sort.categories.help"] = "Choisissez comment les catégories d'inventaire sont triées.",
    ["option.inventory.sort.items.help"] = "Choisissez comment les objets sont triés dans chaque catégorie.",
    ["option.store.columns.help"] = "Définit le nombre de colonnes utilisées dans la grille du store des paramètres.",
    ["option.inventory.search.live.help"] = "Met à jour les résultats de recherche pendant la saisie.",
    ["option.inventory.categories.collapsible.help"] = "Permet de replier et déplier les catégories d'inventaire.",
    ["option.inventory.pagination.page_size.help"] = "Nombre de piles d'inventaire affichées par page.",
    ["option.inventory.actions.confirm_bulk_drop.help"] = "Demande une confirmation avant de jeter plusieurs objets d'une pile.",
    ["inventory.sort.alphabetical"] = "Alphabétique",
    ["inventory.sort.manual"] = "Manuel",
    ["inventory.sort.weight"] = "Poids",
    ["inventory.sort.class"] = "Classe",

    -- Inventory Translations
    ["inventory.weight.abbreviation"] = "kg",

    -- OOC / Notification Translations
    ["notify.chat.ooc.disabled"] = "Le chat OOC est actuellement désactivé sur ce serveur.",
    ["notify.chat.ooc.wait"] = "Veuillez attendre %d seconde(s) avant d'envoyer un autre message OOC.",
    ["notify.chat.ooc.rate_limited"] = "Vous avez atteint la limite de messages OOC (%d) pour les %d dernières minutes.",
    ["error.ragdolled.action"] = "Vous ne pouvez pas effectuer d'actions en ragdoll.",
    ["error.ragdolled.inventory"] = "Vous ne pouvez pas déplacer des objets d'inventaire en ragdoll.",
    ["error.ragdolled.item_interact"] = "Vous ne pouvez pas utiliser des objets en ragdoll.",
    ["error.ragdolled.use"] = "Vous ne pouvez pas utiliser des entités en ragdoll.",
    ["error.ragdolled.vehicle_enter"] = "Vous ne pouvez pas entrer dans des véhicules en ragdoll.",

    ---- Flags
    ["flag.p.name"] = "Permission Physgun",
    ["flag.p.description"] = "Autorise l'utilisation du physgun.",

    ["flag.t.name"] = "Permission Toolgun",
    ["flag.t.description"] = "Autorise l'utilisation du toolgun.",

    ["config.interface.font.antialias"] = "Anticrénelage des polices",
    ["config.interface.font.multiplier"] = "Échelle des polices",

    ["config.interface.vignette.enabled"] = "Activer l'effet de vignette",
    ["config.interface.vignette.enabled.help"] = "Active ou désactive l'effet de vignette sur les bords de l'écran.",

    ["config.interface.buildmenu.requires_tools"] = "Exiger les outils de construction pour les menus Spawn/Context",
    ["config.interface.buildmenu.requires_tools.help"] = "Bloque les menus spawn et context sauf si le joueur tient un outil de construction.",
    ["config.interface.buildmenu.notify_attempts"] = "Tentatives bloquées avant notification",
    ["config.interface.buildmenu.notify_attempts.help"] = "Nombre de pressions bloquées avant d'afficher une notification.",
    ["config.interface.buildmenu.notify_reset_delay"] = "Délai de réinitialisation des notifications bloquées",
    ["config.interface.buildmenu.notify_reset_delay.help"] = "Secondes avant la réinitialisation du compteur de blocage.",

    -- Chatbox
    ["chatbox.entry.placeholder"] = "Dites quelque chose...",
    ["chatbox.recommendations.no_description"] = "Aucune description fournie.",
    ["chatbox.recommendations.truncated"] = "Affichage des %d premiers résultats.",
    ["chatbox.menu.close"] = "Fermer le chat",
    ["chatbox.menu.clear_history"] = "Effacer l'historique du chat",
    ["chatbox.menu.reset_position"] = "Réinitialiser la position",
    ["chatbox.menu.reset_size"] = "Réinitialiser la taille",
    ["chatbox.menu.confirm_clear_title"] = "Effacer l'historique du chat",
    ["chatbox.menu.confirm_clear_message"] = "Effacer tout l'historique du chat ?",

    ["config.chatbox.max_message_length"] = "Longueur max des messages du chat",
    ["config.chatbox.history_size"] = "Taille de l'historique de saisie du chat",
    ["config.chatbox.chat_type_history"] = "Taille de l'historique des types de chat",
    ["config.chatbox.looc_prefix"] = "Préfixe LOOC du chat",
    ["config.chatbox.recommendations.debounce"] = "Délai des recommandations du chat",
    ["config.chatbox.recommendations.animation_duration"] = "Durée d'animation des recommandations du chat",
    ["config.chatbox.recommendations.command_limit"] = "Limite de recommandations de commandes",
    ["config.chatbox.recommendations.voice_limit"] = "Limite de recommandations vocales",
    ["config.chatbox.recommendations.wrap_cycle"] = "Bouclage du cycle de recommandations",

    ["scoreboard.context.copy_steamid"] = "Copier le SteamID",
    ["scoreboard.context.view_profile"] = "Voir le profil"

})
