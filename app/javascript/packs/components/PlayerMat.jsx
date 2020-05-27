import React from "react";
import LitterboxImage from 'images/litterbox.png';
import CatnipImage from 'images/catnip.png';
import ToyImage from 'images/cattoy.png';
import FoodImage from 'images/money.png';

class PlayerMat extends React.Component {
    render = () => {
        const {stats} = this.props;
        return <div className="u-border">
            <h3>
                { stats.userName }
            </h3>
            <div className="u-flex">
                <div> <img className="player-cat-icon" src={FoodImage}/> {stats.food} </div>
                <div> <img className="player-cat-icon" src={ToyImage}/> {stats.toys} </div>
                <div> <img className="player-cat-icon" src={CatnipImage}/> {stats.catnip} </div>
                <div> <img className="player-cat-icon" src={LitterboxImage}/> {stats.litterbox} </div>
                <div> <i className='fa fa-trophy'></i> {stats.owned_cards_count} </div>
            </div>
        </div>
    }
}

export default PlayerMat;