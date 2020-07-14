import React from "react";
import CatCard from "./CatCard";

class IrritatePrompt extends React.Component {
    render = () => {
        const {choice, resetCard, currentPlayer, playChoice, cardRepository} = this.props;
        return <React.Fragment>
            <p>
                {"Select another player who will be receiving the benefit: " + this.renderChoiceValues(choice)}
            </p>
            <div className="u-flex">
                {currentPlayer.owned_cats.map((catCard) => {
                    <CatCard key={catCard.id + '-choice'}
                             interact={() => {playChoice(catCard.id)}}
                             card={cardRepository[catCard.cat_card_id]}/>
                })}
            </div>
            <button onClick={resetCard}>Close</button>
        </React.Fragment>
    }
}

export default IrritatePrompt;