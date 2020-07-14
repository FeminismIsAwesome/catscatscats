import React from "react";

class SwitchPrompt extends React.Component {
    renderChoiceValues = (choice) => {
        var keys = Object.keys(choice.generous);
        return keys.map((key) => choice.generous[key] + " " + key);
    }

    render = () => {
        const {choice, resetCard, playChoice} = this.props;
        const keys = Object.keys(choice.switch);
        return <React.Fragment>
            <span>
                 Choose your benefit:
            </span>
            <div className="u-flex">
                {keys.map((key) => choice.switch[key] + " " + key)}
            </div>
            <button onClick={resetCard}>Close</button>
        </React.Fragment>
    }
}

export default SwitchPrompt;