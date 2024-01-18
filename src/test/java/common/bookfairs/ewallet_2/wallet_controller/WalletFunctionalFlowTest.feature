Feature: Wallet Flow Api tests

  Scenario: User creates wallet, gets the wallet, updates the wallet details, moves the wallet to another fair, then closes the wallet
    # Create an ewallet for an active and existing fair
    Given call read('RunnerHelper.feature@CreateHomepageEvents')
    # Get the wallet details and verify creation
    # Get the fair's wallets to verify creation
    # ?? fund the wallet
    # Get the wallet details and verify funding
    # Update the wallet details
    # Get wallet details and verif changes
    # Move wallet to another fair
    # Get wallet details and verify its in other fair
    # Get other fair wallets and verify its in their list
    # Get previous fair's wallets and verify its not in their list
    # Close the wallet
    # Get wallet details and make sure its closed

    # All things to possibly do before ewallet is closed
    # Possibly fund the wallet?
    # Verify transaction is created
    # Create transaction
    # Verify transaction is created
    # Create wallet release
    # Verify fund in wallet has been released