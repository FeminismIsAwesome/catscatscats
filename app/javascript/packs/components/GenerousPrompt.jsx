import React from "react";

class GenerousPrompt extends React.Component {
    renderChoiceValues = (choice) => {
        var keys = Object.keys(choice.generous);
        return keys.map((key) => choice.generous[key] + " " + key);
    }

    render = () => {
        const {choice, resetCard, otherPlayers, playChoice} = this.props;
        return <React.Fragment>
            <p>
                {"Select another player who will be receiving the benefit: " + this.renderChoiceValues(choice)}
            </p>
            <span>
                 Choose your benefit:
            </span>
            <div className="u-flex">
                {otherPlayers.map((player) => <button className="btn btn-danger" onClick={() => {playChoice(player.name)}}> {player.name} </button>)}
            </div>
            <button onClick={resetCard}>Close</button>
        </React.Fragment>
    }
}

export default GenerousPrompt;