import CatCard from "./CatCard";
import React from "react";

class CatPlayerMat extends React.Component {
    renderCat = (cat, cardRepository) => {
        return <CatCard
            interact={function () {
            }} key={cat.cat_card_id} card={cardRepository[cat.cat_card_id]}/>
    }

    renderHappinessMeme = (level) => {
        if(level <= 1) {
            return <div className="u-text-align-center">
                Pissed! -2 VP
            </div>
        } else if(level == 2) {
            return <div className="u-text-align-center">
                "Expressive" -1 VP
            </div>
        } else if(level == 3) {
            return <div className="u-text-align-center">
                Little Shit! +0 VP
            </div>
        } else if(level == 4) {
            return <div className="u-text-align-center">
                Purrcious +1 VP
            </div>
        } else {
            return <div className="u-text-align-center">
                Lap Cat +2 VP
            </div>
        }
    }

    renderProperty = (player, cardRepository) => {
        if(player.owned_card_ids && player.owned_card_ids.length > 0) {
            return <div className="u-flex cat-row u-4ml--s">
                Their Property:
                {player.owned_card_ids.map((card_id) => {
                    return <React.Fragment>
                        <CatCard
                            interact={function () {
                            }} key={card_id} card={cardRepository[card_id]}/>
                    </React.Fragment>
                })}
            </div>
        }
    }

    render = () => {
        const {cats, cardRepository, player} = this.props;
        const buckets = {}
        cats.forEach((cat) => {
            if(buckets[cat.happiness_level]) {
                buckets[cat.happiness_level].push(cat)
            } else {
                buckets[cat.happiness_level] = [cat]
            }
        })
        return <React.Fragment>
            <h2 className="u-4ml--l u-4mt--l"> {player.name}'s Cats </h2>
            <div className="u-flex">
                {cats.length > 0 && Object.keys(buckets).map((happinessLevel) => {
                    return <React.Fragment key={happinessLevel}>
                        <div className="u-flex u-flex-up-down cat-row u-4ml--s">
                            {this.renderHappinessMeme(happinessLevel)}
                            {buckets[happinessLevel].map((cat) => {
                                return this.renderCat(cat, cardRepository)
                            })}</div>
                    </React.Fragment>
                })}
                { this.renderProperty(player,cardRepository)}
            </div>
        </React.Fragment>
    }
}

export default CatPlayerMat;

