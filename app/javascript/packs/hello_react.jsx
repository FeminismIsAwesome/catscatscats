// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React, {Fragment} from 'react'
import {ActionCableConsumer, ActionCableProvider} from 'react-actioncable-provider';
import {API_WS_ROOT} from './constants';

import CatCard from './components/CatCard';
import PlayerMat from './components/PlayerMat';
import PlayersList from './components/PlayersList';
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

function uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

// const findActiveConversation = (conversations, activeConversation) => {
//   return conversations.find(
//       conversation => conversation.id === activeConversation
//   );
// };

// const mapConversations = (conversations, handleClick) => {
//   return conversations.map(conversation => {
//     return (
//         <li key={conversation.id} onClick={() => handleClick(conversation.id)}>
//           {conversation.title}
//         </li>
//     );
//   });
// };

const TEST_CARDS = ['Treat', 'Lightning Rod', 'Vanilla', 'Chocolate','Spotty'];

class CatsGame extends React.Component {


    constructor(props) {
        super(props);
        this.state = {
            players: props.gameData.players,
            catCards: [], stats: {food: 0, toys: 0, catnip: 0, litterbox: 0},
            currentPlayer: props.gameData.player
        };
    }

    componentDidMount = () => {
        fetch('/cat_cards').then(res => res.json())
            .then(response => {
                this.setState({catCards: response});
            });
    };

    handlePlayerMessage = response => {
        const {message, kind} = response;
        if (kind === 'new_subscription') {
            this.setState({
                players: message
            })
        }
    }

    handleReceivedMessage = response => {
        // console.log("KIKI LETS DO THE FORK IN THE GARBAGE DISPOSAL")
        const {message, kind} = response;
        if (kind === 'stats') {
            const newData = Object.assign({}, this.state.stats, message);
            this.setState({
                stats: newData
            })
        } else if(kind === 'start_game') {
            alert('KRISPY KREME 2012')
        } else if (kind === 'new_subscription') {
            this.setState({
                players: message
            })
        }
    };

    helloWorld = () => {
        console.log("FARRRT");
    }

    yikes = () => {
        console.log("DISCONNECTED YO")
    }

    startGame = () => {
        fetch("/cats_games/2/start_game", {method: 'post'})
    }

    render = () => {
        const {catCards, stats, currentPlayer, players} = this.state;
        const demoCards = catCards.filter((card) => TEST_CARDS.includes(card.title))
        return (
            <div className="conversationsList">
                {/*<ActionCable*/}
                <ActionCableConsumer
                    channel={{channel: 'PlayerChannel', id: currentPlayer.id, cat_game_id: '2'}}
                    onReceived={this.handlePlayerMessage}
                />

                <ActionCableConsumer
                    channel={{channel: 'CatGamesChannel', id: '2'}}
                    onDisconnected={this.yikes}
                    onConnected={this.helloWorld}
                    onReceived={this.handleReceivedMessage}
                />

                <h1>
                    Hello, {currentPlayer.name}! Welcome to Kitty Committee!
                </h1>
                <div class="row">
                    <div class="col-8">
                        <PlayerMat
                            stats={stats}
                        />
                        <div class="u-4ml--l">
                            Select your cards
                        </div>

                        {demoCards.length > 0 && demoCards.map((card) => <CatCard key={card.id} card={card}/>)}
                    </div>
                    <div class="col-4">
                        <button className="btn btn-primary" onClick={this.startGame}>
                            START GAME
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

document.addEventListener('DOMContentLoaded', () => {
    fetch('/cats_games/2/current_state').then(res => res.json())
        .then(response => {
        ReactDOM.render(
            <ActionCableProvider url={API_WS_ROOT}>
                <CatsGame gameData={response}/> </ActionCableProvider>,
            document.body.appendChild(document.createElement('div')),
        )
    });
})
