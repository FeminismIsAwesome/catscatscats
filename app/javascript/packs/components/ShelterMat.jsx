import CatCard from "./CatCard";
import React from "react";

class ShelterMat extends React.Component {
    renderCat = (cat, cardRepository) => {
        return <CatCard
            interact={function () {
            }} key={cat.cat_card_id} card={cardRepository[cat.cat_card_id]}/>
    }

    render = () => {
        const {cats, cardRepository, player} = this.props;
        return <React.Fragment>
            <h2 className="u-4ml--l u-4mt--l"> {player.name}'s Cats </h2>
            <div className="u-flex cat-row u-4ml--s">
                {
                    cats.map((cat) => {
                        return this.renderCat(cat, cardRepository)
                    })
                }
            </div>
        </React.Fragment>
    }
}

export default ShelterMat;

