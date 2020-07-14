import {ActionCableConsumer, ActionCableProvider} from "react-actioncable-provider";
import PlayerMat from "./PlayerMat";
import CatCard from "./CatCard";
import PlayersList from "./PlayersList";
import React from 'react';
import Popup from "reactjs-popup";
import GenerousPrompt from "./GenerousPrompt";
import PettyPrompt from "./PettyPrompt";
import IrritatePrompt from "./IrritatePrompt";
import SwitchPrompt from "./SwitchPrompt";
import StealPrompt from "./StealPrompt";
import CatPlayerMat from './CatPlayerMat'
import ShelterMat from './ShelterMat'

const TEST_CARDS = ['Treat', 'Lightning Rod', 'Vanilla', 'Chocolate', 'Spotty'];

class TimeoutWidget {
    constructor(timeout_length) {
        this.timeout_length = timeout_length
    }

    resetTimeout(timeoutFn) {
        if (this.timeout) {
            clearTimeout(this.timeout);
        }
        this.timeout = setTimeout(timeoutFn, this.timeout_length)
    }
}

let timeoutWidget = new TimeoutWidget(2000);

class CatsGame extends React.Component {


    constructor(props) {
        super(props);
        this.state = {
            players: props.gameData.players,
            cardRepository: props.gameData.cardRepository,
            broadcastMessage: '',
            cardsInHand: [],
            shelterCats: [],
            currentBids: [],
            showLoadingForDraft: false,
            catCards: [], stats: {food: 0, toys: 0, catnip: 0, litterbox: 0},
            currentPlayer: props.gameData.player,
            currentDraftHand: [],
            currentBid: [],
            currentDraftIndex: 0,
            errorNotice: undefined,
            currentTurnPlayer: undefined,
            shelterCatsArray: props.gameData.shelter_cats_array,
        };
    }

    handlePlayerMessage = response => {
        const {message, kind} = response;
        if (kind === 'new_subscription') {
            this.setState({
                players: message
            })
        } else if (kind === 'round_start') {
            this.setState({
                currentDraftHand: message
            })
        }
    }

    isMyTurn = () => {
        const {currentPlayer, currentTurnPlayer} = this.state;
        return currentPlayer.id === currentTurnPlayer.id;
    }

    componentDidMount = () => {
        this.forceDraftRefresh();
    }

    handleReceivedMessage = response => {
        // console.log("KIKI LETS DO THE FORK IN THE GARBAGE DISPOSAL")
        const {message, kind} = response;
        if (kind === 'stats') {
            const newData = Object.assign({}, this.state.stats, message);
            this.setState({
                stats: newData
            })
        } else if (kind === 'new_subscription') {
            this.setState({
                players: message
            })
        } else if (kind === 'refresh_draft_state') {
            this.setState({
                currentDraftHand: []
            });
            this.forceDraftRefresh();
        }
    };

    forceDraftRefresh = () => {
        fetch('/cats_games/' + this.props.game_id + '/refresh_state').then(function (res) {
            return res.json();
        }).then((data) => {
            this.setState({
                broadcastMessage: 'Round 1 Start',
                showLoadingForDraft: data.display_loading,
                currentDraftHand: data.current_draft_hand,
                currentDraftIndex: data.current_draft_index,
                cardsInHand: data.selected_cards,
                doneDrafting: data.state !== 'drafting',
                shelterCats: data.shelter_cats,
                currentTurnPlayer: data.current_turn_player,
                errorNotice: undefined,
                currentBids: data.current_bids,
                players: data.players,
                currentBid: [],
                currentState: data.state,
                shelterCatsArray: data.shelter_cats_array
            });
        });
    }

    startGame = () => {
        fetch("/cats_games/" + this.props.game_id +"/start_game", {method: 'post'})
    }

    dismissAlert = () => {
        this.setState({
            errorNotice: undefined
        })
    }

    simulateCatPhase = () => {
        fetch("/cats_games/" + this.props.game_id + "/simulate_cat_round", {method: 'post'})
    }

    simulateCardPlayingRound = () => {
        fetch("/cats_games/" + this.props.game_id + "/simulate_card_playing_round", {method: 'post'})
    }

    resetBid = () => {
        this.setState({
            currentBid: []
        });
    }

    addToBid = (shelter_cat_id) => {
        let {currentBid, currentPlayer, currentBids} = this.state;
        const currentCatBid = currentBid.find((bid) => bid.shelter_cat_id === shelter_cat_id)
        const bidTotals = currentBid.map((bid) => bid.bid_amount).reduce(function (a, b) {
            return a + b;
        }, 0);
        const alreadyPlacedTotals = currentBids.map((bid) => bid.bid_amount).reduce(function (a, b) {
            return a + b;
        }, 0);
        if (bidTotals + alreadyPlacedTotals >= currentPlayer.energy_count) {
            this.setState({
                errorNotice: 'Cant bid over current energy count!'
            });
            return;
        }
        if (currentCatBid) {
            currentCatBid.bid_amount += 1;
        } else {
            currentBid = currentBid.concat({shelter_cat_id: shelter_cat_id, bid_amount: 1});
        }
        this.setState({
            currentBid: currentBid
        });
    }

    bidOnCats = () => {
        const {currentBid} = this.state;
        fetch('/shelter_cats/bid', {
            body: JSON.stringify({bids: currentBid}),
            headers: {
                'Content-Type': 'application/json'
            },
            method: 'post'
        });
    }

    draftCard = (cardId, pickNum) => {
        return () => {
            fetch(`/cat_cards/${cardId}/pick?card_number=${pickNum}`, {method: 'post'}).then(() => {
                // timeoutWidget.resetTimeout(forceRefresh);
            })
        }
    }

    modifyBid = (shelterCatId) => {
        return () => {
            this.addToBid(shelterCatId);
        }
    }

    passCard = () => {
        fetch(`/cat_cards/pass`, {method: 'post'})
    }

    resetCard = () => {
        this.setState({
            currentChoice: undefined
        })
    }

    renderChoiceValues = (choice) => {
        var keys = Object.keys(choice.generous);
        return keys.map((key) => choice.generous[key] + " " + key);
    }

    renderChoice = (choice) => {
        const { selectedCardId, currentPlayer, players, cardRepository } = this.state;
        if(choice) {
            const hasGenerous = !!choice.generous;
            const hasIrritate = !!choice.irritate;
            const hasPetty = !!choice.petty;
            const hasSwitch = !!choice.switch;
            const hasSteal = !!choice.remove;
            let PopupContent;
            if(hasGenerous) {
                const otherPlayers = players.filter((player) => player.id !== currentPlayer.id);
                PopupContent = <GenerousPrompt playChoice={this.playChoice}
                                               choice={choice}
                                               otherPlayers={otherPlayers}
                                               resetCard={this.resetCard}
                />;
            } else if(hasIrritate) {
                PopupContent = <IrritatePrompt playChoice={this.playChoice}
                                               choice={choice}
                                               currentPlayer={currentPlayer}
                                               cardRepository={cardRepository}
                                               resetCard={this.resetCard} />;
            } else if(hasPetty) {
                const otherPlayers = players.filter((player) => player.id !== currentPlayer.id);
                PopupContent = <PettyPrompt playChoice={this.playChoice}
                                            choice={choice}
                                            otherPlayers={otherPlayers}
                                            resetCard={this.resetCard} />;
            } else if(hasSwitch) {
                PopupContent = <SwitchPrompt playChoice={this.playChoice}
                                             choice={choice}
                                             resetCard={this.resetCard} />;
            } else if(hasSteal) {
                const otherPlayers = players.filter((player) => player.id !== currentPlayer.id);
                PopupContent = <StealPrompt playChoice={this.playChoice}
                                            choice={choice}
                                            otherPlayers={otherPlayers}
                                            resetCard={this.resetCard} />;
            }
            return <Popup
                open={!!choice}
                position="right center"
                closeOnDocumentClick={false}
                onClose={this.resetCard}
            >
                <div className="js-big-window">
                    { PopupContent }
                </div>
            </Popup>
        }
    }

    playChoice = (choice) => {
        const {selectedCardId} = this.state;
        fetch(`/cat_cards/${selectedCardId}/play_choice`, {
            method: 'post',
            body: JSON.stringify({choice: choice}),
            headers: {
                'Content-Type': 'application/json'
            }
        }).then((data) => {
            this.setState({
                currentChoice: undefined
            });
        })
    }

    playCard = () => {
        const {selectedCardId} = this.state;
        fetch(`/cat_cards/${selectedCardId}/play`, {method: 'post'}).then( (res) => {
            this.forceDraftRefresh();
            return res.json();
        }).then((data) => {
            if(data.error) {
                this.setState({
                    errorNotice: data.error
                })
            } else if(data.status) {
                this.setState({
                    errorNotice: undefined
                });
            //    done
            } else {
                this.setState({
                    currentChoice: data
                });
            }
        })
    }

    burnCard = () => {
        const {selectedCardId} = this.state;
        fetch(`/cat_cards/${selectedCardId}/burn`, {method: 'post'})
    }

    highlightCard = (card) => {
        return () => {
            this.setState({selectedCardId: card})
        }
    }


    renderLoading = () => {
        return <div className="u-flex">
            <i className="fas fa-spinner fa-spin big-load-icon"></i>
            <h3> Waiting for other players to pick their cards...
            </h3>
        </div>
    }

    renderDraftDisplay = (catCards, draftNum, cardRepository) => {
        return <React.Fragment>
            <div className="u-4ml--l">
                Drafting Card {draftNum + 1} of 7
            </div>

            <div>
                {catCards.length > 0 && catCards.map((card) => <CatCard key={card}
                                                                        interact={this.draftCard(card, draftNum)}
                                                                        timeoutWidget={timeoutWidget}
                                                                        forceRefresh={this.forceDraftRefresh}
                                                                        card={cardRepository[card]}/>)}
            </div>
        </React.Fragment>
    }

    renderShelterCats = () => {
        const {shelterCats, currentBid, cardRepository, currentTurnPlayer, currentPlayer} = this.state;
        const canPickCards = currentTurnPlayer.id === currentPlayer.id;

        return Object.entries(shelterCats).map(([shelter_cat_id, shelterCat]) => {
            let bids = shelterCat.cat_bids;
            const currentCatBid = currentBid.find((bid) => bid.shelter_cat_id === shelter_cat_id);
            let mergedBids;
            if (currentCatBid) {
                mergedBids = bids.map((serverBid) => {
                    if (serverBid.shelter_cat_id === parseInt(currentCatBid.shelter_cat_id) && serverBid.cat_player_id === currentPlayer.id) {
                        return {
                            shelter_cat_id: serverBid.shelter_cat_id,
                            cat_player_id: serverBid.cat_player_id,
                            cat_player_name: serverBid.cat_player_name,
                            bid_amount: serverBid.bid_amount + currentCatBid.bid_amount
                        }
                    } else {
                        return serverBid;
                    }
                });
                if (!mergedBids.find((bid) => bid.cat_player_id === currentPlayer.id) && currentCatBid) {
                    mergedBids = mergedBids.concat({
                        shelter_cat_id: currentCatBid.shelter_cat_id,
                        cat_player_id: currentPlayer.id,
                        cat_player_name: currentPlayer.name,
                        bid_amount: currentCatBid.bid_amount
                    })
                }
            } else {
                mergedBids = bids;
            }
            return <div>
                <CatCard
                    interact={this.modifyBid(shelter_cat_id)}
                    key={shelterCat.cat_card_id}
                    timeoutWidget={timeoutWidget}
                    forceRefresh={this.forceDraftRefresh}
                    card={cardRepository[shelterCat.cat_card_id]}/>
                {mergedBids.map((bid) => {
                    return <div>
                        Bid by {bid.cat_player_name} for {bid.bid_amount}
                    </div>
                })}
            </div>
        })
    }

    renderCurrentDecisions = () => {
        const {currentDraftIndex, currentChoice, currentState, errorNotice, cardRepository, currentDraftHand, showLoadingForDraft, doneDrafting, currentTurnPlayer} = this.state;
        const catCards = currentDraftHand;


        if (!doneDrafting) {
            return <React.Fragment>
                {showLoadingForDraft && this.renderLoading()}
                {!showLoadingForDraft && this.renderDraftDisplay(catCards, currentDraftIndex, cardRepository)}
            </React.Fragment>
        } else if (currentState === 'cat_bidding') {
            return <React.Fragment>
                {errorNotice &&
                <p className="alert alert-danger">
                    {errorNotice}
                    <i className="fa fa-times u-4ml--l" onClick={this.dismissAlert}/>
                </p>
                }
                <p>
                    Welcome to the Cat Choosing Phase!
                </p>

                <p>
                    Current player is {currentTurnPlayer.name}
                </p>

                <p>
                    Bids will be...
                </p>
                <div className="u-flex">
                    {this.isMyTurn() && <React.Fragment>
                        <button className="btn btn-primary" onClick={this.bidOnCats}>
                            Seal in Bid
                        </button>
                        <button className="btn btn-secondary" onClick={this.bidOnCats}>
                            Pass
                        </button>
                        <button className="button btn-danger u-4ml--l" onClick={this.resetBid}>
                            Undo current bid
                        </button>
                    </React.Fragment>}
                </div>
                <div className="u-flex">
                    {this.renderShelterCats()}
                </div>
            </React.Fragment>
        } else if (currentState === 'card_playing') {
            return <React.Fragment>
                <p>
                    Welcome to the Card Playing phase!
                </p>
                <p>
                    Current player is {currentTurnPlayer.name}
                </p>

                <p>
                    To play a card for its ability, click then press play.
                </p>

                <p>
                    To burn a card for energy, click a card then press "burn".
                </p>
                <p>
                    Once done doing actions for the round, press pass.
                </p>
                <div className="u-flex">
                    <button className="btn btn-primary" onClick={this.playCard}>
                        Play Card
                    </button>

                    <button className="btn btn-danger u-4ml--l" onClick={this.burnCard}>
                        Burn Card for 1 Energy
                    </button>

                    <button className="btn btn-danger u-4ml--l" onClick={this.passCard}>
                        Pass
                    </button>
                </div>
                {errorNotice &&
                <p className="alert alert-danger">
                    {errorNotice}
                    <i className="fa fa-times u-4ml--l" onClick={this.dismissAlert}/>
                </p>
                }
                {this.renderChoice(currentChoice)}
            </React.Fragment>
        } else if(currentState === 'cat_feeding') {
            return <React.Fragment>
                <p>
                    Welcome to the Cat Feeding phase!
                </p>
                <p>
                    Tell Ian which cats you are satisfying needs/greeds of, and he will run the code to process the results.
                </p>
            </React.Fragment>
        }
    }

    render = () => {
        const {cardRepository, selectedCardId, shelterCatsArray, stats, currentPlayer, players, broadcastMessage, cardsInHand} = this.state;
        return (
            <div className="cats-game-js">

                <div className="alert alert-info">
                    {broadcastMessage}
                </div>
                {/*<ActionCable*/}
                <ActionCableConsumer
                    channel={{channel: 'PlayerChannel', id: currentPlayer.id, cat_game_id: '2'}}
                    onReceived={this.handlePlayerMessage}
                />

                <ActionCableConsumer
                    channel={{channel: 'CatGamesChannel', id: '2'}}
                    onReceived={this.handleReceivedMessage}
                />

                <h1>
                    Hello, {currentPlayer.name}! Welcome to Kitty Committee!
                </h1>
                <div className="row">
                    <div className="col-9">
                        <PlayerMat
                            stats={stats}
                        />
                        {this.renderCurrentDecisions()}
                        <h2 className="u-4ml--l u-4mt--l"> Cards in Hand (Selected)</h2>
                        <div>
                            {cardsInHand.length > 0 && cardsInHand.map((card) => <CatCard
                                selectedCardId={selectedCardId} interact={this.highlightCard(card)} key={card}
                                card={cardRepository[card]}/>)}
                        </div>

                        <h2 className="u-4ml--l u-4mt--l"> Cats </h2>


                        <ShelterMat player={{name: 'Shelter Kitties'}} cats={shelterCatsArray} cardRepository={cardRepository} />

                        <CatPlayerMat player={currentPlayer} cats={currentPlayer.owned_cats} cardRepository={cardRepository} />

                        {players.filter((player) => player.id !== currentPlayer.id).map((player) => <CatPlayerMat player={player} cats={player.owned_cats} cardRepository={cardRepository}  />)}

                    </div>
                    <div className="col-3">
                        <button className="btn btn-secondary" onClick={this.forceDraftRefresh}>
                            HARD REFRESH IF STUCK
                        </button>
                        <button className="btn btn-primary" onClick={this.startGame}>
                            START GAME
                        </button>
                        <button className="btn btn-danger" onClick={this.simulateCatPhase}>
                            Simulate Cat Phase
                        </button>
                        <button className="btn btn-warning" onClick={this.simulateCardPlayingRound}>
                            Simulate Card Playing Round
                        </button>
                        <PlayersList
                            players={players}
                        />
                    </div>
                </div>
            </div>
        );
    };
}

export default CatsGame;