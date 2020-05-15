// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React,{Fragment} from 'react'
import { ActionCableConsumer, ActionCableProvider } from 'react-actioncable-provider';
import { API_WS_ROOT } from './constants';

import CatCard from './components/CatCard';
import PlayerMat from './components/PlayerMat';
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const Hello = props => (
  <div>Hello {props.name}!
    <CatsGame />
  </div>
)

Hello.defaultProps = {
  name: 'David'
}

Hello.propTypes = {
  name: PropTypes.string
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

const TEST_CARDS = ['Treat', 'Lightning Rod'];

class CatsGame extends React.Component {
  state = {
    cats: [], catCards: [], stats: { treats: 0}
  };

  componentDidMount = () => {
    fetch('/conversations')
        .then(res => res.json())
        .then(cats => {
          this.setState({ cats: cats.cats });
        } );

    fetch('/cat_cards').then(res => res.json())
        .then(response => {
            this.setState({ catCards: response });
        } );
  };

  handleReceivedConversation = response => {
    const { message, kind } = response;
    if(kind === 'stats') {
        this.setState({
            stats: message
        })
    }
    // this.setState({
    //   conversations: [...this.state.conversations, conversation]
    // });
  };

  handleReceivedMessage = response => {
      const { cats } = this.state;
      this.setState({cats: cats.concat(response.data)})
  };

  helloWorld = () => {
      console.log("FARRRT");
  }

  yikes = () => {
      console.log("DISCONNECTED YO")
  }

  iSwear = () => {
      fetch("/cat_cards/1/act", {method: 'post'})
  }

  render = () => {
    const { cats, catCards, stats } = this.state;
    const demoCards = catCards.filter((card) => TEST_CARDS.includes(card.title))
    return (
        <div className="conversationsList">
          {/*<ActionCable*/}
          { cats.map(cat => {
            return (<Fragment key={cat}>
                  <div> {cat} </div>
                </Fragment>
            )
          })}

          <ActionCableConsumer
              channel="ConversationsChannel"
              onDisconnected={this.yikes}
              onConnected={this.helloWorld}
              onReceived={this.handleReceivedMessage}
          />

          <PlayerMat
              stats={stats}
              />

          <button onClick={this.iSwear}>
              Fuck you
          </button>
          {/*    channel={{ channel: 'ConversationsChannel' }}*/}
          {/*    onReceived={this.handleReceivedConversation}*/}
          />
          {/*<CatCable*/}
          {/*    conversations={conversations}*/}
          {/*    handleReceivedMessage={this.handleReceivedMessage}*/}
          {/*/>*/}
            { demoCards.length > 0 && demoCards.map((card) => <CatCard key={card.id} card={card} /> ) }
          <h2>Conversations</h2>
        </div>
    );
  };
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
      <ActionCableProvider url={API_WS_ROOT}>
          <Hello name="React" /> </ActionCableProvider>,
    document.body.appendChild(document.createElement('div')),
  )
})
