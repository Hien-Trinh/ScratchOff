extends Node

# Handles signals for transmitting values between 
# objects that are not directly connected.

signal player_money_updated(new_value) # New value should be a double
signal ticket_inventory_updated(new_value) # New value should be an ArrayList
signal upgrade_inventory_updated(new_value) # New value should be an ArrayList
signal mult_updated(new_value)
