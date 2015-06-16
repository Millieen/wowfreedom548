How to modify database for WoW Freedom code:

1. Make sure to have fully set up MoP SkyFire 548 DB.
2. Execute ./rbac_permissions.sql
3. Execute ./update_world_playercreateinfo.sql
4. Execute all SQL files under ./table_creations folder.
5. Execute ./alterations/alter_world_creature_1_addcolumns.sql 
   (upon failure: make sure to drop/remove the partially added columns manually before trying again)
6. Execute ./alterations/alter_world_gameobject_1_addcolumns.sql
   (upon failure: make sure to drop/remove the partially added columns manually before trying again)
7. Execute ./alterations/alter_world_gameobject_2_remove_id_gaps.sql if you want to remove gaps between game object IDs.
   (WARNING: Irreversible operation! Make sure to have a backup of the original tables.)
8. Execute ./alterations/alter_world_item_template_1_addcolumns_mallavailability.sql
9. You are all done!