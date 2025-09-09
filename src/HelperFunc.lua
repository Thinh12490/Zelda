function hitboxesOverlap(hitbox1, hitbox2)
    return not (hitbox1.x + hitbox1.width < hitbox2.x or
                hitbox1.x > hitbox2.x + hitbox2.width or
                hitbox1.y + hitbox1.height < hitbox2.y or
                hitbox1.y > hitbox2.y + hitbox2.height)
end